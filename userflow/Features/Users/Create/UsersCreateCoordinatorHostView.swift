//
//  UsersCreateCoordinatorHostView.swift
//  userflow
//

import SwiftUI

/// Placeholder de alta — **`MT-10`** usará **`UserFormValidators`** (**`MT-09`**) igual que **`createLocalUser`**.
struct UsersCreateCoordinatorHostView: View {
    let repository: UserRepository

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: String.LocalizationValue("users.coordinator.createPlaceholder")))
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(String(localized: String.LocalizationValue("users.coordinator.cachedUsersLabel")))
            Text("\(cachedUserCount)")
                .font(.headline.monospacedDigit())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }

    private var cachedUserCount: Int {
        (try? repository.listUsersForDisplay().count) ?? 0
    }
}
