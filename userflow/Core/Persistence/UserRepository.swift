//
//  UserRepository.swift
//  userflow
//

import Foundation
import RealmSwift

enum UserRepositoryError: Error {
    case userNotFound(localId: String)
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
}

@MainActor
final class DefaultUserRepository: UserRepository {
    private let remote: UsersRemoteServicing

    init(remote: UsersRemoteServicing) {
        self.remote = remote
    }

    func listUsersForDisplay() throws -> [UserListItem] {
        let realm = try openRealm()
        let live = realm.objects(UserObject.self).where { $0.isDeleted == false }
        let items = live.map { UserListItem(realmObject: $0) }
        return items.sorted(by: UserListItem.sortForList)
    }

    func refreshRemoteUsers() async throws {
        let dtos = try await remote.fetchUsers()
        let realm = try openRealm()
        try realm.write {
            for dto in dtos {
                let pk = UserObject.primaryKey(for: dto)
                if let existing = realm.object(ofType: UserObject.self, forPrimaryKey: pk) {
                    existing.applyRemoteSnapshot(localId: pk, dto: dto)
                } else {
                    realm.add(UserObject(localId: pk, remote: dto))
                }
            }
        }
    }

    func createLocalUser(name: String, username: String, email: String, phone: String, city: String) throws -> UserListItem {
        let realm = try openRealm()
        let row = UserObject(localOnlyName: name, username: username, email: email, phone: phone, city: city)
        try realm.write {
            realm.add(row)
        }
        return UserListItem(realmObject: row)
    }

    func setEditedName(localId: String, value: String?) throws {
        try setOptionalEdit(localId: localId) { $0.editedName = Self.normalizeEdit(value) }
    }

    func setEditedEmail(localId: String, value: String?) throws {
        try setOptionalEdit(localId: localId) { $0.editedEmail = Self.normalizeEdit(value) }
    }

    func setLocalDisplayEdits(localId: String, editedName: String?, editedEmail: String?) throws {
        let realm = try openRealm()
        guard let user = realm.object(ofType: UserObject.self, forPrimaryKey: localId) else {
            throw UserRepositoryError.userNotFound(localId: localId)
        }
        try realm.write {
            user.editedName = Self.normalizeEdit(editedName)
            user.editedEmail = Self.normalizeEdit(editedEmail)
        }
    }

    func userDetailSnapshot(localId: String) throws -> UserDetailSnapshot {
        let realm = try openRealm()
        guard let obj = realm.object(ofType: UserObject.self, forPrimaryKey: localId), !obj.isDeleted else {
            throw UserRepositoryError.userNotFound(localId: localId)
        }
        return UserDetailSnapshot(realmObject: obj)
    }

    private func setOptionalEdit(localId: String, apply: (UserObject) -> Void) throws {
        let realm = try openRealm()
        guard let user = realm.object(ofType: UserObject.self, forPrimaryKey: localId) else {
            throw UserRepositoryError.userNotFound(localId: localId)
        }
        try realm.write {
            apply(user)
        }
    }

    private static func normalizeEdit(_ raw: String?) -> String? {
        guard let raw else { return nil }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func openRealm() throws -> Realm {
        try Realm()
    }
}
