//
//  UserFormValidators.swift
//  userflow
//

import Foundation

// MT-09: pure helpers for **`MT-10`** (alta) / detalle donde aplique (**`MT-08`** email en guardar).

/// Single-field outcome for **`UserFormValidators`** (**`MT-09`**).
enum UserFormValidationFailure: Equatable, Error {
    /// Required text is empty after trimming whitespace/newlines.
    case empty
    case emailInvalid
    case phoneInvalid
}

extension UserFormValidationFailure {
    /// Localization key in **`Localizable`** (`validation.*`).
    var localizationKey: String {
        switch self {
        case .empty:
            return "validation.empty"
        case .emailInvalid:
            return "validation.emailInvalid"
        case .phoneInvalid:
            return "validation.phoneInvalid"
        }
    }

    var localizedDescription: String {
        String(localized: String.LocalizationValue(localizationKey))
    }
}

enum UserFormValidators {
    /// Trims **`CharacterSet.whitespacesAndNewlines`**; fails with **`.empty`** if nothing left.
    static func trimmedRequiredNonEmpty(_ raw: String) -> Result<String, UserFormValidationFailure> {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .failure(.empty) }
        return .success(trimmed)
    }

    /// Whitespace-only → **`nil`**; otherwise shape-check (single **`@`**, host with **`.`**, no spaces).
    static func trimmedOptionalEmail(_ raw: String) -> Result<String?, UserFormValidationFailure> {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .success(nil) }
        return isPlausibleEmail(trimmed) ? .success(trimmed) : .failure(.emailInvalid)
    }

    /// Whitespace-only → **`nil`**; otherwise requires a sensible digit count (allows **`+`**, spaces, hyphens, parens).
    static func trimmedOptionalPhone(_ raw: String) -> Result<String?, UserFormValidationFailure> {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .success(nil) }
        return isPlausiblePhone(trimmed) ? .success(trimmed) : .failure(.phoneInvalid)
    }

    /// Runs **`trimmedOptionalEmail`** then **`trimmedOptionalPhone`** (email first).
    static func trimmedOptionalContact(email rawEmail: String, phone rawPhone: String)
        -> Result<(email: String?, phone: String?), UserFormValidationFailure> {
        switch trimmedOptionalEmail(rawEmail) {
        case let .failure(f): return .failure(f)
        case let .success(email):
            switch trimmedOptionalPhone(rawPhone) {
            case let .failure(f): return .failure(f)
            case let .success(phone): return .success((email, phone))
            }
        }
    }

    private static func isPlausibleEmail(_ trimmed: String) -> Bool {
        if trimmed.contains(where: \.isWhitespace) { return false }
        let parts = trimmed.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2 else { return false }
        let local = parts[0]
        let domain = parts[1]
        if local.isEmpty || domain.isEmpty { return false }
        if domain.contains("@") { return false }
        if !domain.contains(".") { return false }
        if domain.hasPrefix(".") || domain.hasSuffix(".") { return false }
        let tld = domain.split(separator: ".").last.map(String.init) ?? ""
        if tld.count < 2 { return false }
        return true
    }

    private static func isPlausiblePhone(_ trimmed: String) -> Bool {
        let digits = trimmed.filter(\.isNumber).count
        return (7...22).contains(digits)
    }
}

extension Result where Failure == UserFormValidationFailure {
    func validatedOrThrow() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let reason):
            throw UserRepositoryError.validationFailed(reason: reason)
        }
    }
}
