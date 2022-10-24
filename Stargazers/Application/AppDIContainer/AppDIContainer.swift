//
//  AppDIContainer.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    
    lazy var githubApiService: DefaultGithubService = {
        DefaultGithubService(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            apiKey: String(data: Data(appConfiguration.apiKey), encoding: .utf8)!
        )
    }()

}
