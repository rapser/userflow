//
//  UserDTO.swift
//  userflow
//
//  Created by miguel tomairo on 07/05/26.
//

import Foundation

/// Remote user row from `GET /users` or `DELETE /users/:id` context (plan: project `address.city`).
struct UserDTO: Equatable, Identifiable, Sendable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: AddressDTO
    let phone: String
    let website: String
    let company: CompanyDTO
}

struct AddressDTO: Equatable, Sendable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: GeoDTO
}

struct GeoDTO: Equatable, Sendable {
    let lat: String
    let lng: String
}

struct CompanyDTO: Equatable, Sendable {
    let name: String
    let catchPhrase: String
    let bs: String
}

// MARK: - Decodable (nonisolated so Alamofire async decoders accept `Decodable & Sendable` under default MainActor isolation)

extension UserDTO: Decodable {
    nonisolated init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        username = try c.decode(String.self, forKey: .username)
        email = try c.decode(String.self, forKey: .email)
        address = try c.decode(AddressDTO.self, forKey: .address)
        phone = try c.decode(String.self, forKey: .phone)
        website = try c.decode(String.self, forKey: .website)
        company = try c.decode(CompanyDTO.self, forKey: .company)
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, username, email, address, phone, website, company
    }
}

extension AddressDTO: Decodable {
    nonisolated init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        street = try c.decode(String.self, forKey: .street)
        suite = try c.decode(String.self, forKey: .suite)
        city = try c.decode(String.self, forKey: .city)
        zipcode = try c.decode(String.self, forKey: .zipcode)
        geo = try c.decode(GeoDTO.self, forKey: .geo)
    }

    private enum CodingKeys: String, CodingKey {
        case street, suite, city, zipcode, geo
    }
}

extension GeoDTO: Decodable {
    nonisolated init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        lat = try c.decode(String.self, forKey: .lat)
        lng = try c.decode(String.self, forKey: .lng)
    }

    private enum CodingKeys: String, CodingKey {
        case lat, lng
    }
}

extension CompanyDTO: Decodable {
    nonisolated init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        catchPhrase = try c.decode(String.self, forKey: .catchPhrase)
        bs = try c.decode(String.self, forKey: .bs)
    }

    private enum CodingKeys: String, CodingKey {
        case name, catchPhrase, bs
    }
}
