//
//  GitHubAPIResponses.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 25.10.2020.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
}

// MARK: - AuthorizationResponse
struct AuthorizationResponse: Codable {
    let id: Int?
    let url: String?
    let app: App?
    let token, hashedToken, tokenLastEight, note: String?
    let noteURL: String?
    let createdAt, updatedAt: String?
    let scopes: [String]?
    let fingerprint: String?
    let message: String?
    let documentationURL: String?

    enum CodingKeys: String, CodingKey {
        case id, url, app, token
        case hashedToken = "hashed_token"
        case tokenLastEight = "token_last_eight"
        case note
        case noteURL = "note_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case scopes, fingerprint
        case message
        case documentationURL = "documentation_url"
    }
}

// MARK: - App
struct App: Codable {
    let name: String?
    let url: String?
    let clientID: String?

    enum CodingKeys: String, CodingKey {
        case name, url
        case clientID = "client_id"
    }
}
