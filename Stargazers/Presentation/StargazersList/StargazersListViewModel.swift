//
//  StargazersListViewModel.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import Combine
import SmartNet
import OrderedCollections

struct StargazersListViewModelActions {
    let showStargazer: (Stargazer) -> Void
}

protocol StargazersListViewModelInput {
    /// Show stargazer details at index path
    /// - Parameter indexPath: stargazer index path
    func showStargazer(at indexPath: IndexPath)
    
    /// Fetch the first page of stargazers, which by default can have a maximum of 30 elements.
    /// - Parameters:
    ///   - repoOwner: Repository owner
    ///   - repoName: Repository name
    func fetchFirstPage(repoOwner: String, repoName: String)
    
    /// Fetch the next stargazers page
    func fetchNextPage()
    
    /// Clear the stargazers list
    func clearStargazers()
}

protocol StargazersListViewModelOutput {
    var stargazers: CurrentValueSubject<OrderedSet<Stargazer>, Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    var isEmpty: Bool { get }
    var isValidRepo: Bool { get }
}

typealias StargazersListViewModel = StargazersListViewModelInput & StargazersListViewModelOutput

final class DefaultStargazersListViewModel: StargazersListViewModel {
    
    private let actions: StargazersListViewModelActions?
    private let githubService: GithubService
    private var fetchStargazersCancellableTask: NetworkCancellable?
    private lazy var lastRepoOwnerSearched: String = ""
    private lazy var lastRepoNameSearched: String = ""
    
    // MARK: - StargazersListViewModelOutput
    
    let stargazers: CurrentValueSubject<OrderedSet<Stargazer>, Never> = .init([])
    let error: PassthroughSubject<String, Never> = .init()
    var isEmpty: Bool { stargazers.value.isEmpty }
    var isValidRepo: Bool = false
    
    // Compute the current page considering that the number of results per page
    // is equal to 30 (default) -> https://docs.github.com/en/rest/activity/starring#about-the-starring-api
    var currentPage: Int {
        guard stargazers.value.count > 0 else { return 0 }
        return max(stargazers.value.count / 30, 1)
    }
    
    init(
        githubService: GithubService,
        actions: StargazersListViewModelActions? = nil
    ) {
        self.githubService = githubService
        self.actions = actions
    }

}

// MARK: - StargazersListViewModelInput
 
extension DefaultStargazersListViewModel {
    func fetchFirstPage(repoOwner: String, repoName: String) {
        // Save last search parameters
        lastRepoOwnerSearched = repoOwner
        lastRepoNameSearched = repoName
        
        // Cancel previous api call if still in progress
        fetchStargazersCancellableTask?.cancel()
        
        fetchStargazersCancellableTask = githubService.fetchStargazers(
            repoOwner: repoOwner,
            repoName: repoName,
            page: 1,
            progressHUD: ProgressHUD.shared
        ) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let stargazers):
                self.stargazers.value = OrderedSet(stargazers.reversed())
                self.isValidRepo = true
                
            case .failure(let error):
                self.isValidRepo = false
                if error.statusCode == 404 {
                    self.error.send(
                        "Repository not found!\n Make sure you are entering valid informations and try again."
                    )
                }
            }
        }
    }
    
    func fetchNextPage() {
        // Cancel previous api call if still in progress
        fetchStargazersCancellableTask?.cancel()
        
        fetchStargazersCancellableTask = githubService.fetchStargazers(
            repoOwner: lastRepoOwnerSearched,
            repoName: lastRepoNameSearched,
            page: currentPage + 1,
            progressHUD: ProgressHUD.shared
        ) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let stargazers):
                var tmpCollection = self.stargazers.value
                stargazers.forEach {
                    tmpCollection.insert($0, at: 0)
                }
                self.stargazers.value = tmpCollection
                
            case .failure(let error):
                self.error.send(
                    error.localizedDescription
                )
            }
        }
    }
    
    func showStargazer(at indexPath: IndexPath) {
        guard
            let stargazer = stargazers.value[safe: indexPath.row]
        else { return }
        actions?.showStargazer(stargazer)
    }
    
    func clearStargazers() {
        stargazers.value = .init()
        isValidRepo = false
    }
}
