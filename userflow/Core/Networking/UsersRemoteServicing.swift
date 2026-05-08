//
//  UsersRemoteServicing.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation

/// Remote contract for JSONPlaceholder `/users`. Repository (MT-05) composes this with Realm.
protocol UsersRemoteServicing: AnyObject {
    func fetchUsers() async throws -> [UserDTO]
    func deleteUser(id: Int) async throws
}
