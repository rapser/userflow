//
//  UsersFlowCoordinator.swift
//  userflow
//

import Combine
import SwiftUI

/// Navegación MVVM+C: lista (**`MT-07`**), detalle (**`MT-08`** / **`MT-11`**), alta (**`MT-10`**, **`MT-12`** ubicación en sheet).
@MainActor
final class UsersFlowCoordinator: ObservableObject, AppCoordinating {
    let repository: UserRepository

    @Published var detailLocalId: String?
    @Published var isPresentingCreateUser = false

    init(repository: UserRepository) {
        self.repository = repository
    }

    func rootView() -> some View {
        UsersFlowRootView(coordinator: self)
    }
}

// MARK: - Root

struct UsersFlowRootView: View {
    @ObservedObject var coordinator: UsersFlowCoordinator

    var body: some View {
        NavigationView {
            UsersListCoordinatorHostView(coordinator: coordinator)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            coordinator.isPresentingCreateUser = true
                        } label: {
                            Image(systemName: "plus")
                                .accessibilityLabel(String(localized: String.LocalizationValue("users.coordinator.accessibility.addUser")))
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $coordinator.isPresentingCreateUser) {
            NavigationView {
                UsersCreateCoordinatorHostView(repository: coordinator.repository)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                coordinator.isPresentingCreateUser = false
                            } label: {
                                Text(String(localized: String.LocalizationValue("button.cancel")))
                            }
                        }
                    }
                    .navigationTitle(String(localized: String.LocalizationValue("users.create.navigationTitle")))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
