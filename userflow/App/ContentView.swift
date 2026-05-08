//
//  ContentView.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("User Flow")
                .font(.title.bold())
            Text("Users")
                .font(.headline)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
