//
//  StargazersFlowCoordinator.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation

final class StargazersFlowCoordinator: FlowCoordinator {
    func start(
        githubService: GithubService
    ) {
        let actions = StargazersListViewModelActions(
            showStargazer: showStargazer
        )
        let viewModel = DefaultStargazersListViewModel(
            githubService: githubService,
            actions: actions
        )
        let viewController = StargazersListViewController.create(with: viewModel)
        startFlow(with: viewController)
    }
}

private extension StargazersFlowCoordinator {
    func showStargazer(stargazer: Stargazer) {
        print("Show user details")
    }
}
