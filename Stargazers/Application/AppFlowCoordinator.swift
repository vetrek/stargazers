//
//  AppFlowCoordinator.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import UIKit

final class AppFlowCoordinator: FlowCoordinator {
    
    private var appDIContainer: AppDIContainer!
    
    func start(appDIContainer: AppDIContainer) {
        StargazersFlowCoordinator(
            navigationController: navigationController
        ).start(githubService: appDIContainer.githubApiService)
    }
}
