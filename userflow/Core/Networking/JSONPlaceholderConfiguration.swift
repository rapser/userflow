//
//  JSONPlaceholderConfiguration.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation

enum JSONPlaceholderConfiguration {
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!

    static var usersListURL: URL {
        baseURL.appendingPathComponent("users", isDirectory: false)
    }

    static func userURL(id: Int) -> URL {
        usersListURL.appendingPathComponent("\(id)", isDirectory: false)
    }
}
