//
//  userflowApp.swift
//  userflow
//
//  Created by miguel tomairo on 7/05/26.
//

import RealmSwift
import SwiftUI

@main
struct userflowApp: App {
    init() {
        // MT-01: ensure RealmSwift links; does not open a Realm file.
        _ = Realm.Configuration.defaultConfiguration.fileURL
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
