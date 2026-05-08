//
//  userflowApp.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Alamofire
import RealmSwift
import SwiftUI

@main
struct userflowApp: App {
    init() {
        // MT-04: schema + migration version before first file open.
        RealmBootstrap.configureDefault()
        // MT-01: RealmSwift linked — default configuration file URL (opens storage lazily on first Realm()).
        _ = Realm.Configuration.defaultConfiguration.fileURL
        // MT-02: Alamofire linked via SPM — hold default session so the dependency is exercised.
        _ = Session.default
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
