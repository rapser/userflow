//
//  RealmRemoteMergeSupport.swift
//  userflow
//

import Foundation
import RealmSwift

/// Archivo aparte (**sin** tipos **`@MainActor`**) para que **`realmRemoteMergeQueue`** no sea MainActor-isolated en modo Swift 6.
private let realmRemoteMergeQueue = DispatchQueue(label: "io.userflow.userRepository.remoteMerge", qos: .userInitiated)

enum RealmRemoteMergeSupport {
    static func mergeUsersFromRemotePayload(dtos: [UserDTO], configuration: Realm.Configuration) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            realmRemoteMergeQueue.async {
                do {
                    try autoreleasepool {
                        let realm = try Realm(configuration: configuration)
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
                    cont.resume()
                } catch {
                    AppDiagnostics.recordHandledError(error, context: "DefaultUserRepository.refreshRemoteUsers.realmMerge(background)")
                    cont.resume(throwing: error)
                }
            }
        }
    }
}
