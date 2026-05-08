//
//  UsersCreateViewModel.swift
//  userflow
//

import Combine
import Foundation

/// Alta local (**`MT-10`**); validación vía **`UserRepository.createLocalUser`** (**`MT-09`**).
@MainActor
final class UsersCreateViewModel: ObservableObject {
    private let repository: UserRepository

    @Published var nameDraft: String = ""
    @Published var usernameDraft: String = ""
    @Published var emailDraft: String = ""
    @Published var phoneDraft: String = ""
    @Published var cityDraft: String = ""

    @Published private(set) var isSaving: Bool = false
    @Published private(set) var saveErrorMessage: String?

    init(repository: UserRepository) {
        self.repository = repository
    }

    func save(onSuccess: @escaping () -> Void) {
        guard !isSaving else { return }
        saveErrorMessage = nil
        isSaving = true
        defer { isSaving = false }

        do {
            _ = try repository.createLocalUser(
                name: nameDraft,
                username: usernameDraft,
                email: emailDraft,
                phone: phoneDraft,
                city: cityDraft
            )
            onSuccess()
        } catch UserRepositoryError.validationFailed(let reason) {
            saveErrorMessage = reason.localizedDescription
        } catch UserRepositoryError.userNotFound {
            saveErrorMessage = String(localized: String.LocalizationValue("users.detail.notFound"))
        } catch {
            saveErrorMessage = AppError.unknown.userFacingMessage
        }
    }

    func clearSaveError() {
        saveErrorMessage = nil
    }
}
