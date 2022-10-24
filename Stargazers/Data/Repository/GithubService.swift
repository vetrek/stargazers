//
//  StargazersRepository.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import SmartNet

/// Github service errors
enum GithubServiceError: Error {
    case fetchFailed(statusCode: Int, networkError: NetworkError)
    
    var statusCode: Int {
        switch self {
        case .fetchFailed(let statusCode, _):
            return statusCode
        }
    }
    
    var networkError: NetworkError {
        switch self {
        case .fetchFailed(_, let networkError):
            return networkError
        }
    }
}

/// Github Services
protocol GithubService {
    
    /// Fetch the stargazers list of any Githhub repo
    /// - Parameters:
    ///   - repoOwner: Repository owner
    ///   - repoName: Repository name
    ///   - page: Page to fetch
    ///   - progressHUD: Progress HUD to show a loading indicator to the user
    ///   - completion: completion block
    /// - Returns: Returns a cancellable request
    func fetchStargazers(
        repoOwner: String,
        repoName: String,
        page: Int,
        progressHUD: SNProgressHUD?,
        completion: @escaping (Swift.Result<[Stargazer], GithubServiceError>) -> Void
    ) -> NetworkCancellable?
}
