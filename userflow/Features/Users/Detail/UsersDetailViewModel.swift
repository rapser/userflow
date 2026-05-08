//
//  UsersDetailViewModel.swift
//  userflow
//

import Combine
import Foundation

@MainActor
final class UsersDetailViewModel: ObservableObject {
    private let localId: String
    private let repository: UserRepository

    @Published private(set) var snapshot: UserDetailSnapshot?
    @Published private(set) var loadFailedMessage: String?

    @Published var isEditing: Bool = false
    @Published var nameDraft: String = ""
    @Published var emailDraft: String = ""

    /// Save failed (shows inline banner).
    @Published private(set) var saveErrorMessage: String?

    init(localId: String, repository: UserRepository) {
        self.localId = localId
        self.repository = repository
    }

    func reload() {
        saveErrorMessage = nil
        do {
            snapshot = try repository.userDetailSnapshot(localId: localId)
            loadFailedMessage = nil
            primeDraftsFromSnapshot()
        } catch UserRepositoryError.userNotFound {
            snapshot = nil
            loadFailedMessage = String(localized: String.LocalizationValue("users.detail.notFound"))
        } catch {
            snapshot = nil
            loadFailedMessage = AppError.unknown.userFacingMessage
        }
    }

    func beginEditing() {
        saveErrorMessage = nil
        primeDraftsFromSnapshot()
        isEditing = true
    }

    func cancelEditing() {
        isEditing = false
        primeDraftsFromSnapshot()
        saveErrorMessage = nil
    }

    func saveEdits() {
        saveErrorMessage = nil
        let nameTrim = nameDraft.trimmingCharacters(in: .whitespacesAndNewlines)

        let nameSubmission: String? = nameTrim.isEmpty ? nil : nameTrim

        let emailSubmission: String?
        switch UserFormValidators.trimmedOptionalEmail(emailDraft) {
        case .failure(let reason):
            saveErrorMessage = reason.localizedDescription
            return
        case .success(let validated):
            emailSubmission = validated
        }

        do {
            try repository.setLocalDisplayEdits(localId: localId, editedName: nameSubmission, editedEmail: emailSubmission)
            isEditing = false
            reload()
        } catch UserRepositoryError.userNotFound {
            saveErrorMessage = String(localized: String.LocalizationValue("users.detail.notFound"))
        } catch {
            saveErrorMessage = AppError.unknown.userFacingMessage
        }
    }

    func clearSaveError() {
        saveErrorMessage = nil
    }

    private func primeDraftsFromSnapshot() {
        guard let snapshot else {
            nameDraft = ""
            emailDraft = ""
            return
        }
        nameDraft = snapshot.displayName
        emailDraft = snapshot.displayEmail
    }
}
