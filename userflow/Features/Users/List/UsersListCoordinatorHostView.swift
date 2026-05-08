//
//  UsersListCoordinatorHostView.swift
//  userflow
//

import SwiftUI

/// Host de navegación hacia detalle (**`MT-07`** sustituye el contenido).
struct UsersListCoordinatorHostView: View {
    @ObservedObject var coordinator: UsersFlowCoordinator

    private var detailActiveBinding: Binding<Bool> {
        Binding(
            get: { coordinator.detailLocalId != nil },
            set: { active in
                if !active { coordinator.detailLocalId = nil }
            }
        )
    }

    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: String.LocalizationValue("users.coordinator.listPlaceholder")))
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Button {
                    coordinator.detailLocalId = UserPrimaryKey.forRemoteUser(apiId: 1)
                } label: {
                    Label(String(localized: String.LocalizationValue("users.coordinator.sampleDetail")), systemImage: "person.crop.circle")
                }

                NavigationLink(
                    "",
                    destination: UsersDetailCoordinatorHostView(
                        localUserId: coordinator.detailLocalId ?? "",
                        repository: coordinator.repository
                    ),
                    isActive: detailActiveBinding
                )
                .frame(width: 0, height: 0)
                .hidden()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .navigationTitle(String(localized: String.LocalizationValue("users.screenTitle")))
        }
    }
}
