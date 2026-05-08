//
//  NetworkingError.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation

/// Typed failures from the JSONPlaceholder / Alamofire layer (MT-03).
enum NetworkingError: Error {
    case invalidHTTPStatus(code: Int)
    case decoding(underlying: Error)
    case transport(underlying: Error)
}

extension NetworkingError {
    /// Collapses transport-layer problems into the shared `AppError` surface for UI.
    func asAppError() -> AppError {
        switch self {
        case .decoding:
            return .decodingFailed
        case .invalidHTTPStatus, .transport:
            return .networkUnavailable
        }
    }
}
