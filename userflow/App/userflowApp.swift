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
        // MT-01: RealmSwift linked via SPM — does not open a Realm file.
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
