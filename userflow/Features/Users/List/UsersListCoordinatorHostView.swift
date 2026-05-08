//
//  UsersListCoordinatorHostView.swift
//  userflow
//

import SwiftUI
import UIKit

/// Lista principal (**`GET /users`** + merge Realm via **`UsersListViewModel`**). Detalle (**`MT-08`**) navega por **`NavigationLink(tag:selection:)`** (**iOS 15**).
struct UsersListCoordinatorHostView: View {
    @ObservedObject var coordinator: UsersFlowCoordinator
    @StateObject private var viewModel: UsersListViewModel

    init(coordinator: UsersFlowCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: UsersListViewModel(repository: coordinator.repository))
    }

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemGroupedBackground)
                .ignoresSafeArea()

            content
        }
        .navigationTitle(String(localized: String.LocalizationValue("users.screenTitle")))
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchText, prompt: Text(String(localized: String.LocalizationValue("users.list.searchPrompt"))))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if viewModel.isLoading, !viewModel.rows.isEmpty {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .accessibilityLabel(String(localized: String.LocalizationValue("users.list.loadingA11y")))
                }
            }
        }
        .task {
            await viewModel.loadInitial()
        }
        .refreshable {
            await viewModel.refreshUsers()
        }
        .onChange(of: coordinator.isPresentingCreateUser) { presenting in
            if !presenting {
                Task { await viewModel.reloadFromCache() }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading, viewModel.rows.isEmpty {
            ProgressView(String(localized: String.LocalizationValue("users.list.loadingA11y")))
                .progressViewStyle(.circular)
        } else if let cacheError = viewModel.cacheErrorMessage {
            Text(cacheError)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding()
        } else if viewModel.filteredRows.isEmpty {
            Text(String(localized: String.LocalizationValue("users.list.empty")))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
                .padding(.top, 48)
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 14) {
                    if let banner = viewModel.refreshWarning {
                        Text(banner)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 18)
                            .padding(.top, 6)
                            .accessibilityIdentifier("users.list.refreshBanner")
                    }

                    ForEach(viewModel.filteredRows) { item in
                        NavigationLink(
                            destination: UsersDetailCoordinatorHostView(
                                localUserId: item.localId,
                                repository: coordinator.repository,
                                onDeleted: {
                                    coordinator.detailLocalId = nil
                                    Task { await viewModel.reloadFromCache() }
                                }
                            ),
                            tag: item.localId,
                            selection: $coordinator.detailLocalId
                        ) {
                            UserListCardRow(item: item)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(uiColor: .systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                                .padding(.horizontal, 16)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 12)
                .padding(.bottom, 8)
            }
        }
    }
}
