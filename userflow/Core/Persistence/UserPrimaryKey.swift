//
//  UserPrimaryKey.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation

/// Stable `UserObject.localId` rules for **`MT-05` merge** (deterministic remote vs fresh local-only rows).
enum UserPrimaryKey {
    /// Rows backed by JSONPlaceholder `User.id` keep a deterministic primary key across downloads.
    static func forRemoteUser(apiId: Int) -> String {
        "remote-\(apiId)"
    }

    /// Locally created users before any remote id exists (`apiId == 0`).
    static func generateLocalOnly() -> String {
        UUID().uuidString
    }
}
