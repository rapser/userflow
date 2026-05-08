//
//  AppError.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation

/// Shared domain errors surfaced to the presentation layer — detailed mapping grows with MT-03+.
enum AppError: Equatable, Error {
    case networkUnavailable
    case decodingFailed
    case unknown

    /// Localization key consumed by `Resources/Localizable.xcstrings` (fallback via key if missing).
    var localizationKey: String {
        switch self {
        case .networkUnavailable:
            return "error.networkUnavailable"
        case .decodingFailed:
            return "error.decodingFailed"
        case .unknown:
            return "error.unknown"
        }
    }

    /// User-facing summary for alerts and placeholders (localized when catalog is wired).
    var userFacingMessage: String {
        String(localized: String.LocalizationValue(localizationKey))
    }
}
