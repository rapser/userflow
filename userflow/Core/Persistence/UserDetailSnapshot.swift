//
//  UserDetailSnapshot.swift
//  userflow
//

import Foundation
import RealmSwift

/// Read model for **`MT-08`** detail screen (mirror de **`UserObject`** sin exponer Realm en UI).
struct UserDetailSnapshot: Equatable, Sendable {
    let localId: String
    let apiId: Int
    let isLocallyCreated: Bool

    let displayName: String
    let displayEmail: String

    /// Valores en snapshot remoto antes de **`editedName` / `editedEmail`**.
    let syncedName: String
    let syncedEmail: String

    let username: String
    let phone: String
    let website: String

    let street: String
    let suite: String
    let city: String
    let zipcode: String

    let geoLat: String
    let geoLng: String

    let companyName: String
    let companyCatchPhrase: String
    let companyBusinessSegment: String

    var formattedAddressLines: String {
        let cityLine = [zipcode.trimmingCharacters(in: .whitespacesAndNewlines), city.trimmingCharacters(in: .whitespacesAndNewlines)]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        let parts = [street, suite, cityLine]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return parts.joined(separator: "\n")
    }

    var geoLine: String {
        let a = geoLat.trimmingCharacters(in: .whitespacesAndNewlines)
        let b = geoLng.trimmingCharacters(in: .whitespacesAndNewlines)
        if a.isEmpty, b.isEmpty { return "" }
        return "\(a), \(b)"
    }

    init(realmObject obj: UserObject) {
        localId = obj.localId
        apiId = obj.apiId
        isLocallyCreated = obj.isLocallyCreated

        syncedName = obj.name
        syncedEmail = obj.email
        displayName = Self.pickDisplay(override: obj.editedName, fallback: obj.name)
        displayEmail = Self.pickDisplay(override: obj.editedEmail, fallback: obj.email)

        username = obj.username
        phone = obj.phone
        website = obj.website

        street = obj.street
        suite = obj.suite
        city = obj.city
        zipcode = obj.zipcode

        geoLat = obj.geoLat
        geoLng = obj.geoLng

        companyName = obj.companyName
        companyCatchPhrase = obj.companyCatchPhrase
        companyBusinessSegment = obj.companyBusinessSegment
    }

    private static func pickDisplay(override: String?, fallback: String) -> String {
        let t = override?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !t.isEmpty { return t }
        return fallback
    }
}
