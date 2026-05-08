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
    @Published var searchText: String = ""

    /// Shown while first load or full refresh is in flight before any rows exist.
    @Published private(set) var isLoading: Bool = false

    /// Surfaced when **`refreshRemoteUsers`** fails; list may still show cached Realm rows (**`MT-05`** policy).
    @Published private(set) var refreshWarning: String?

    /// Hard failure reading Realm for the list projection.
    @Published private(set) var cacheErrorMessage: String?

    init(repository: UserRepository) {
        self.repository = repository
    }

    var filteredRows: [UserListItem] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return rows }

        return rows.filter { item in
            item.displayName.localizedCaseInsensitiveContains(q)
                || item.username.localizedCaseInsensitiveContains(q)
                || item.phone.localizedCaseInsensitiveContains(q)
                || item.displayEmail.localizedCaseInsensitiveContains(q)
                || item.city.localizedCaseInsensitiveContains(q)
        }
    }

    func loadInitial() async {
        await refreshUsers()
    }

    func refreshUsers() async {
        isLoading = true
        refreshWarning = nil
        defer { isLoading = false }

        do {
            try await repository.refreshRemoteUsers()
        } catch let error as NetworkingError {
            refreshWarning = error.asAppError().userFacingMessage
        } catch {
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
            rows = []
            cacheErrorMessage = AppError.unknown.userFacingMessage
        }
    }
}
