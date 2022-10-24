//
//  Endpoint.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import SmartNet

enum EndpointsConfig {
    case stargazers(repoOwner: String, repoName: String)
    
    var path: String {
        switch self {
        case .stargazers(let repoOwner, let repoName):
            return "/repos/\(repoOwner)/\(repoName)/stargazers"
        }
    }
}

enum Endpoints {
    static func fetchStargazers(
        repoOwner: String,
        repoName: String,
        page: Int
    ) -> Endpoint<StargazersResponseDTO> {
        Endpoint(
            path: EndpointsConfig.stargazers(repoOwner: repoOwner, repoName: repoName).path,
            headers: ["Accept": "application/vnd.github.v3.star+json"],
            queryParameters: QueryParameters(
                parameters: ["page": page]
            )
        )
    }
}
