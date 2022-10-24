//
//  StargazersResponseDTO.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation

typealias StargazersResponseDTO = [StargazersResponseDTOElement]

// MARK: - Data Transfer Object

struct StargazersResponseDTOElement: Codable {
    let starredAt: Date?
    let user: UserDTO

    enum CodingKeys: String, CodingKey {
        case starredAt = "starred_at"
        case user = "user"
    }
}

extension StargazersResponseDTOElement {
    struct UserDTO: Codable {
        let login: String
        let id: Int
        let nodeID: String?
        let avatarURL: String?
        let gravatarID: String?
        let url: String?
        let htmlURL: String?
        let followersURL: String?
        let followingURL: String?
        let gistsURL: String?
        let starredURL: String?
        let subscriptionsURL: String?
        let organizationsURL: String?
        let reposURL: String?
        let eventsURL: String?
        let receivedEventsURL: String?
        let type: String?
        let siteAdmin: Bool?

        enum CodingKeys: String, CodingKey {
            case login = "login"
            case id = "id"
            case nodeID = "node_id"
            case avatarURL = "avatar_url"
            case gravatarID = "gravatar_id"
            case url = "url"
            case htmlURL = "html_url"
            case followersURL = "followers_url"
            case followingURL = "following_url"
            case gistsURL = "gists_url"
            case starredURL = "starred_url"
            case subscriptionsURL = "subscriptions_url"
            case organizationsURL = "organizations_url"
            case reposURL = "repos_url"
            case eventsURL = "events_url"
            case receivedEventsURL = "received_events_url"
            case type = "type"
            case siteAdmin = "site_admin"
        }
    }
}

// MARK: - Mappings to Domain

extension StargazersResponseDTO {
    func toDomain() -> [Stargazer] {
        compactMap { $0.toDomain() }
    }
}

extension StargazersResponseDTOElement {
    func toDomain() -> Stargazer {
        Stargazer(
            user: user.toDomain(),
            starredAt: starredAt
        )
    }
}

extension StargazersResponseDTOElement.UserDTO {
    func toDomain() -> GithubUser {
        GithubUser(
            id: id,
            userName: login,
            avatarURL: URL(string: avatarURL ?? "")
        )
    }
}
