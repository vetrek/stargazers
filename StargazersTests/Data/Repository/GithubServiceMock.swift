//
//  MockedGithubService.swift
//  StargazersTests
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import XCTest
import SmartNet
@testable import Stargazers

class GithubServiceMock: GithubService {
    var expectation: XCTestExpectation?
    var stargazers: [Stargazer] = []
    var error: GithubServiceError?
    
    func fetchStargazers(
        repoOwner: String,
        repoName: String,
        page: Int,
        progressHUD: SNProgressHUD? = nil,
        completion: @escaping (Swift.Result<[Stargazer], GithubServiceError>) -> Void
    ) -> NetworkCancellable? {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(stargazers))
        }
        expectation?.fulfill()
        return nil
    }
}
