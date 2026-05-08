//
//  UsersListViewModel.swift
//  userflow
//

import Combine
import Foundation

@MainActor
final class UsersListViewModel: ObservableObject {
    private let repository: UserRepository

    @Published private(set) var rows: [UserListItem] = []
    @Published var searchText: String = "" {
        didSet { recomputeFilteredRows() }
    }

    /// Derivado de **`rows`** + **`searchText`**; evita re-filtrar en cada evaluación del **`body`** al desplazar.
    @Published private(set) var filteredRows: [UserListItem] = []

    /// Shown while first load or full refresh is in flight before any rows exist.
    @Published private(set) var isLoading: Bool = false

    /// Surfaced when **`refreshRemoteUsers`** fails; list may still show cached Realm rows (**`MT-05`** policy).
    @Published private(set) var refreshWarning: String?

    /// Hard failure reading Realm for the list projection.
    @Published private(set) var cacheErrorMessage: String?

    private var didRunInitialRefresh = false

    init(repository: UserRepository) {
        self.repository = repository
        recomputeFilteredRows()
    }

    private func recomputeFilteredRows() {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty {
            filteredRows = rows
            return
        }

        filteredRows = rows.filter { item in
            item.displayName.localizedCaseInsensitiveContains(q)
                || item.username.localizedCaseInsensitiveContains(q)
                || item.phone.localizedCaseInsensitiveContains(q)
                || item.displayEmail.localizedCaseInsensitiveContains(q)
                || item.city.localizedCaseInsensitiveContains(q)
        }
    }

    func loadInitial() async {
        guard !didRunInitialRefresh else { return }
        didRunInitialRefresh = true
        reloadFromCacheSynchronously()
        await refreshUsers()
    }

    func refreshUsers() async {
        isLoading = true
        refreshWarning = nil
        defer { isLoading = false }

        do {
            try await repository.refreshRemoteUsers()
        } catch let error as NetworkingError {
            AppDiagnostics.recordHandledError(error, context: "UsersListViewModel.refreshUsers")
            refreshWarning = error.asAppError().userFacingMessage
        } catch {
            AppDiagnostics.recordHandledError(error, context: "UsersListViewModel.refreshUsers.unexpected")
            refreshWarning = AppError.unknown.userFacingMessage
        }

        reloadFromCacheSynchronously()
    }

    /// Reloads from Realm only (e.g. after dismissing create-user sheet).
    func reloadFromCache() async {
        reloadFromCacheSynchronously()
    }

    private func reloadFromCacheSynchronously() {
        do {
            rows = try repository.listUsersForDisplay()
            cacheErrorMessage = nil
        } catch {
            AppDiagnostics.recordHandledError(error, context: "UsersListViewModel.reloadFromCacheSynchronously(listUsersForDisplay)")
            rows = []
            cacheErrorMessage = AppError.unknown.userFacingMessage
        }
        recomputeFilteredRows()
    }
}
