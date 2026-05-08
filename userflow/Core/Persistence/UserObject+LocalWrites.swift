//
//  UserObject+LocalWrites.swift
//  userflow
//

import Foundation

extension UserObject {
    /// Call inside a Realm **write** transaction. `apiId` stays **`0`** until remote linkage (**future** pushes).
    convenience init(localOnlyName name: String, username: String, email: String, phone: String, city: String) {
        self.init()
        localId = UserPrimaryKey.generateLocalOnly()
        apiId = 0
        isDeleted = false
        isLocallyCreated = true

        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.city = city
    }
}
