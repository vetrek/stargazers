//
//  DefaultStargazersRepository.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import SmartNet

final class DefaultGithubService: GithubService {
  
    // MARK: - Private Properties
    
    private let network: SmartNet
    
    // MARK: - Init
    
    init(
        baseURL: URL,
        apiKey: String
    ) {
        network = SmartNet(
            config: NetworkConfiguration(
                baseURL: baseURL,
                headers: ["Authorization": "Bearer \(apiKey)"]
            )
        )
    }
    
    // MARK: - Github Service
    
    func fetchStargazers(
        repoOwner: String,
        repoName: String,
        page: Int = 1,
        progressHUD: SNProgressHUD? = nil,
        completion: @escaping (Swift.Result<[Stargazer], GithubServiceError>) -> Void
    ) -> NetworkCancellable? {
        network.request(
            with: Endpoints.fetchStargazers(
                repoOwner: repoOwner,
                repoName: repoName,
                page: page
            ),
            progressHUD: progressHUD
        ) { response in
            switch response.result {
            case .success(let data):
                completion(
                    .success(data.toDomain())
                )
                
            case .failure(let error):
                completion(
                    .failure(
                        GithubServiceError.fetchFailed(
                            statusCode: response.statusCode,
                            networkError: error)
                    )
                )
            }
        }
    }
}
