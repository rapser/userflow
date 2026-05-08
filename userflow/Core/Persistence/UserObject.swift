//
//  UserObject.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation
import RealmSwift

/// Realm mirror of a user row (remote snapshot + local overrides + logical delete). Used from **MT-05** repository merge onward.
final class UserObject: Object {
    /// Primary key: use `UserPrimaryKey` helpers (`remote-*` vs UUID for local-only).
    @Persisted(primaryKey: true) var localId: String = ""

    /// JSONPlaceholder `id`; **`0` means app-created / not yet linked remotely**.
    @Persisted(indexed: true) var apiId: Int = 0

    /// Tombstone: excluded from visible list after logical delete (**`MT-11`** / merge policy).
    @Persisted(indexed: true) var isDeleted: Bool = false

    /// `true` when the row was created only on-device (no remote id yet).
    @Persisted var isLocallyCreated: Bool = false

    // MARK: Remote snapshot (from API / DTO)

    @Persisted var name: String = ""
    @Persisted var username: String = ""
    @Persisted var email: String = ""
    @Persisted var phone: String = ""
    @Persisted var website: String = ""

    @Persisted var street: String = ""
    @Persisted var suite: String = ""
    @Persisted var city: String = ""
    @Persisted var zipcode: String = ""

    @Persisted var geoLat: String = ""
    @Persisted var geoLng: String = ""

    @Persisted var companyName: String = ""
    @Persisted var companyCatchPhrase: String = ""
    @Persisted var companyBusinessSegment: String = ""

    // MARK: Local edits (truth after user edit — **`MT-08` / merge**).

    @Persisted var editedName: String?
    @Persisted var editedEmail: String?
}
