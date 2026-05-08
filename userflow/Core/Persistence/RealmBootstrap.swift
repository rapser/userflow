//
//  RealmBootstrap.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation
import RealmSwift

enum RealmBootstrap {
    /// Bump when adding/removing **`Object`** subclasses or reshaping persisted properties.
    static let schemaVersion: UInt64 = 1

    static func configureDefault() {
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Initial schema shipped with **`UserObject`** (`MT-04`).
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
}
