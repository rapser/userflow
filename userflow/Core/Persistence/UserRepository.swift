//
//  UserRepository.swift
//  userflow
//

import Foundation
import RealmSwift

enum UserRepositoryError: Error {
    case userNotFound(localId: String)

    /// **`MT-09`**: alta local rechaza campos obligatorios vacíos / formato (**`validation.*`**).
    case validationFailed(reason: UserFormValidationFailure)
}

/// Composes JSONPlaceholder + Realm and merge policy from **`docs/development-plan.md`** (**`MT-05`**).
@MainActor
protocol UserRepository: AnyObject {
    /// Users with **`isDeleted == false`**, display fields honoring **`editedName`** / **`editedEmail`**.
    func listUsersForDisplay() throws -> [UserListItem]

    /// **`GET /users`** then upsert by **`apiId`**; does not clear **`isDeleted`** (**`UserObject.applyRemoteSnapshot`**).
    func refreshRemoteUsers() async throws

    func createLocalUser(name: String, username: String, email: String, phone: String, city: String) throws -> UserListItem

    /// `nil` clears the override so the remote snapshot field is shown again.
    func setEditedName(localId: String, value: String?) throws

    /// `nil` clears the override.
    func setEditedEmail(localId: String, value: String?) throws

    /// **MT-08**: escritura única sobre Realm para nombre/email visual (normaliza trims).
    func setLocalDisplayEdits(localId: String, editedName: String?, editedEmail: String?) throws

    /// Snapshot persistido (**`MT-08`**): falla si no existe la fila o está **`isDeleted`**.
    func userDetailSnapshot(localId: String) throws -> UserDetailSnapshot

    /// **`MT-11`**: **`DELETE /users/:id`** cuando **`apiId > 0`**; siempre marca **`isDeleted`** en Realm (solo local si **`apiId == 0`**).
    func deleteUser(localId: String) async throws
}

@MainActor
final class DefaultUserRepository: UserRepository {
    private let remote: UsersRemoteServicing

    /// Serializa lecturas/escrituras Realm en foreground (`@MainActor`) cuando la UI espera resultado inmediato.
    /// El merge del **`GET /users`** va por **`RealmRemoteMergeSupport`** (sin **`@MainActor`**) y **no** usa este lock.
    private let realmLock = NSLock()

    init(remote: UsersRemoteServicing) {
        self.remote = remote
    }

    private func withLockedRealm<R>(_ body: (Realm) throws -> R) throws -> R {
        realmLock.lock()
        defer { realmLock.unlock() }
        let realm = try Realm()
        return try body(realm)
    }

    private func withLockedRealmWrite<R>(_ body: (Realm) throws -> R) throws -> R {
        realmLock.lock()
        defer { realmLock.unlock() }
        let realm = try Realm()
        return try realm.write {
            try body(realm)
        }
    }

    private func logged<T>(_ context: String, _ operation: () throws -> T) throws -> T {
        do {
            return try operation()
        } catch {
            AppDiagnostics.recordHandledError(error, context: context)
            throw error
        }
    }

    func listUsersForDisplay() throws -> [UserListItem] {
        try logged("DefaultUserRepository.listUsersForDisplay") {
            try withLockedRealm { realm in
                let live = realm.objects(UserObject.self).where { $0.isDeleted == false }
                let items = live.map { UserListItem(realmObject: $0) }
                return items.sorted(by: UserListItem.sortForList)
            }
        }
    }

    func refreshRemoteUsers() async throws {
        let dtos = try await remote.fetchUsers()
        let configuration = Realm.Configuration.defaultConfiguration
        try await RealmRemoteMergeSupport.mergeUsersFromRemotePayload(dtos: dtos, configuration: configuration)
    }

    func createLocalUser(name: String, username: String, email: String, phone: String, city: String) throws -> UserListItem {
        let nameTrimmed = try UserFormValidators.trimmedRequiredNonEmpty(name).validatedOrThrow()
        let usernameTrimmed = try UserFormValidators.trimmedRequiredNonEmpty(username).validatedOrThrow()
        let cityTrimmed = try UserFormValidators.trimmedRequiredNonEmpty(city).validatedOrThrow()

        let emailStored = try UserFormValidators.trimmedOptionalEmail(email).validatedOrThrow() ?? ""
        let phoneStored = try UserFormValidators.trimmedOptionalPhone(phone).validatedOrThrow() ?? ""

        return try logged("DefaultUserRepository.createLocalUser.realmWrite") {
            try withLockedRealmWrite { realm in
                let row = UserObject(
                    localOnlyName: nameTrimmed,
                    username: usernameTrimmed,
                    email: emailStored,
                    phone: phoneStored,
                    city: cityTrimmed
                )
                realm.add(row)
                return UserListItem(realmObject: row)
            }
        }
    }

    func setEditedName(localId: String, value: String?) throws {
        try setOptionalEdit(localId: localId) { $0.editedName = Self.normalizeEdit(value) }
    }

    func setEditedEmail(localId: String, value: String?) throws {
        try setOptionalEdit(localId: localId) { $0.editedEmail = Self.normalizeEdit(value) }
    }

    func setLocalDisplayEdits(localId: String, editedName: String?, editedEmail: String?) throws {
        _ = try logged("DefaultUserRepository.setLocalDisplayEdits") {
            try withLockedRealmWrite { realm in
                guard let user = realm.object(ofType: UserObject.self, forPrimaryKey: localId) else {
                    throw UserRepositoryError.userNotFound(localId: localId)
                }
                user.editedName = Self.normalizeEdit(editedName)
                user.editedEmail = Self.normalizeEdit(editedEmail)
                return ()
            }
        }
    }

    func userDetailSnapshot(localId: String) throws -> UserDetailSnapshot {
        try logged("DefaultUserRepository.userDetailSnapshot") {
            try withLockedRealm { realm in
                guard let obj = realm.object(ofType: UserObject.self, forPrimaryKey: localId), !obj.isDeleted else {
                    throw UserRepositoryError.userNotFound(localId: localId)
                }
                return UserDetailSnapshot(realmObject: obj)
            }
        }
    }

    func deleteUser(localId: String) async throws {
        let remoteId: Int = try logged("DefaultUserRepository.deleteUser.readMeta") {
            try withLockedRealm { realm in
                guard let row = realm.object(ofType: UserObject.self, forPrimaryKey: localId), !row.isDeleted else {
                    throw UserRepositoryError.userNotFound(localId: localId)
                }
                return row.apiId
            }
        }

        if remoteId > 0 {
            do {
                try await remote.deleteUser(id: remoteId)
            } catch {
                AppDiagnostics.recordHandledError(error, context: "DefaultUserRepository.deleteUser.remoteDELETE")
                throw error
            }
        }

        do {
            try withLockedRealmWrite { realm in
                if let inner = realm.object(ofType: UserObject.self, forPrimaryKey: localId), !inner.isDeleted {
                    inner.isDeleted = true
                }
            }
        } catch {
            AppDiagnostics.recordHandledError(error, context: "DefaultUserRepository.deleteUser.tombstone")
            throw error
        }
    }

    private func setOptionalEdit(localId: String, apply: (UserObject) -> Void) throws {
        _ = try logged("DefaultUserRepository.setOptionalEdit") {
            try withLockedRealmWrite { realm in
                guard let user = realm.object(ofType: UserObject.self, forPrimaryKey: localId) else {
                    throw UserRepositoryError.userNotFound(localId: localId)
                }
                apply(user)
                return ()
            }
        }
    }

    private static func normalizeEdit(_ raw: String?) -> String? {
        guard let raw else { return nil }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

}
