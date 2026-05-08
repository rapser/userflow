//
//  ContentView.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var usersCoordinator = UsersFlowCoordinator(
        repository: DefaultUserRepository(remote: JSONPlaceholderUsersClient())
    )

    var body: some View {
        usersCoordinator.rootView()
    }
}

#Preview {
    ContentView()
}
