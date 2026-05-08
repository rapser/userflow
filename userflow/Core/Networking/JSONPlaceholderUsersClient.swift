//
//  JSONPlaceholderUsersClient.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Alamofire
import Foundation

/// Alamofire-backed client for [`/users`](https://jsonplaceholder.typicode.com/users). Delete is simulated server-side (`MT-11`).
final class JSONPlaceholderUsersClient: UsersRemoteServicing {
    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchUsers() async throws -> [UserDTO] {
        do {
            return try await session.request(JSONPlaceholderConfiguration.usersListURL)
                .validate(statusCode: 200 ..< 300)
                .serializingDecodable([UserDTO].self, decoder: decoder)
                .value
        } catch {
            AppDiagnostics.recordHandledError(error, context: "JSONPlaceholderUsersClient.fetchUsers")
            throw Self.mapFetchError(error)
        }
    }

    func deleteUser(id: Int) async throws {
        do {
            _ = try await session.request(JSONPlaceholderConfiguration.userURL(id: id), method: .delete)
                .validate(statusCode: 200 ..< 300)
                .serializingData()
                .value
        } catch {
            AppDiagnostics.recordHandledError(error, context: "JSONPlaceholderUsersClient.deleteUser(\(id))")
            throw Self.mapDeleteError(error)
        }
    }

    private static func mapFetchError(_ error: Error) -> NetworkingError {
        if let decoding = error as? DecodingError {
            return .decoding(underlying: decoding)
        }

        guard let af = error as? AFError else {
            return .transport(underlying: error)
        }

        if case let .responseValidationFailed(reason) = af,
           case let .unacceptableStatusCode(code) = reason {
            return .invalidHTTPStatus(code: code)
        }

        if case let .responseSerializationFailed(reason) = af {
            switch reason {
            case let .decodingFailed(underlying):
                if let decoding = underlying as? DecodingError {
                    return .decoding(underlying: decoding)
                }
            default:
                break
            }
        }

        if let decoding = unwrapDecodingError(from: af) {
            return .decoding(underlying: decoding)
        }

        return .transport(underlying: af)
    }

    private static func mapDeleteError(_ error: Error) -> NetworkingError {
        guard let af = error as? AFError else {
            return .transport(underlying: error)
        }
        if case let .responseValidationFailed(reason) = af,
           case let .unacceptableStatusCode(code) = reason {
            return .invalidHTTPStatus(code: code)
        }
        return .transport(underlying: af)
    }

    private static func unwrapDecodingError(from af: AFError) -> DecodingError? {
        var current: Error? = af.underlyingError
        while let wrapped = current {
            if let decoding = wrapped as? DecodingError {
                return decoding
            }
            current = (wrapped as? AFError)?.underlyingError
        }
        return nil
    }
}
