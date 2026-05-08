//
//  UserObject+RemoteDTO.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation
import RealmSwift

extension UserObject {
    /// Preferred primary key for a JSONPlaceholder-backed user.
    static func primaryKey(for dto: UserDTO) -> String {
        UserPrimaryKey.forRemoteUser(apiId: dto.id)
    }

    /// Call inside a Realm **write** transaction.
    convenience init(localId: String, remote dto: UserDTO) {
        self.init()
        applyRemoteSnapshot(localId: localId, dto: dto)
    }

    /// Applies a remote snapshot; intended for **`MT-05` upserts** inside a write transaction.
    /// Does **not** change **`isDeleted`** so a tombstone survives remote re-fetches (**`MT-11`** merge policy).
    ///
    /// **Primary key**: only set **`localId`** while the row is **unmanaged** (`realm == nil`).
    /// After **`realm.add(...)`**, Realm forbids assigning the PK (`Primary key can't be changed after...`).
    func applyRemoteSnapshot(localId: String, dto: UserDTO) {
        if realm == nil {
            self.localId = localId
        }
        apiId = dto.id
        isLocallyCreated = false

        name = dto.name
        username = dto.username
        email = dto.email
        phone = dto.phone
        website = dto.website

        street = dto.address.street
        suite = dto.address.suite
        city = dto.address.city
        zipcode = dto.address.zipcode
        geoLat = dto.address.geo.lat
        geoLng = dto.address.geo.lng

        companyName = dto.company.name
        companyCatchPhrase = dto.company.catchPhrase
        companyBusinessSegment = dto.company.bs
    }
}
