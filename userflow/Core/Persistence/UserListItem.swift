//
//  UserListItem.swift
//  userflow
//

import Foundation

/// Projection for list/search UI (**`MT-07`**) produced by **`UserRepository`** merge rules (**`MT-05`**).
struct UserListItem: Equatable, Identifiable, Sendable {
    var id: String { localId }

    let localId: String
    let apiId: Int
    let displayName: String
    let displayEmail: String
    let username: String
    let phone: String
    let city: String
    let isLocallyCreated: Bool
}

extension UserListItem {
    /// Reads current persisted fields on the invoking thread (same Realm as **`object`**).
    init(realmObject object: UserObject) {
        localId = object.localId
        apiId = object.apiId
        displayName = UserListItem.displayField(override: object.editedName, fallback: object.name)
        displayEmail = UserListItem.displayField(override: object.editedEmail, fallback: object.email)
        username = object.username
        phone = object.phone
        city = object.city
        isLocallyCreated = object.isLocallyCreated
    }

    private static func displayField(override: String?, fallback: String) -> String {
        let trimmed = override?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !trimmed.isEmpty {
            return trimmed
        }
        return fallback
    }

    /// Sort suitable for searchable list (**`development-plan`**): name ascending, tie-break **`localId`**.
    static func sortForList(_ lhs: Self, _ rhs: Self) -> Bool {
        let order = lhs.displayName.localizedCaseInsensitiveCompare(rhs.displayName)
        if order != .orderedSame {
            return order == .orderedAscending
        }
        return lhs.localId < rhs.localId
    }
}
