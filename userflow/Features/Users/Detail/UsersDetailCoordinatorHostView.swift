//
//  UsersDetailCoordinatorHostView.swift
//  userflow
//

import SwiftUI

/// Placeholder de detalle — **`MT-08`** arma la UI real.
struct UsersDetailCoordinatorHostView: View {
    let localUserId: String
    let repository: UserRepository

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: String.LocalizationValue("users.coordinator.detailPlaceholder")))
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let row = (try? repository.listUsersForDisplay())?.first(where: { $0.localId == localUserId }) {
                Text(row.displayName)
                    .font(.headline)
                Text(row.displayEmail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text(localUserId)
                .font(.title3.monospaced())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .navigationTitle(String(localized: String.LocalizationValue("users.detail.navigationTitle")))
    }
}
