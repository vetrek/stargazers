//
//  StargazersListViewModelMock.swift
//  StargazersTests
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import XCTest
@testable import Stargazers

class StargazersListViewModelTests: XCTestCase {
    
    let stargazers: [Stargazer] = (0...59).compactMap {
        Stargazer(
            user: GithubUser(
                id: $0,
                userName: "\($0)",
                avatarURL: nil),
            starredAt: Date()
        )
    }
    
    func test_whenFetchStargazersRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() {
        // given
        let githubServiceMock = GithubServiceMock()
        githubServiceMock.expectation = self.expectation(description: "First page loaded")
        githubServiceMock.stargazers = Array(stargazers[0..<30])
        let viewModel = DefaultStargazersListViewModel(githubService: githubServiceMock)
        // when
        viewModel.fetchFirstPage(
            repoOwner: "owner",
            repoName: "name"
        )
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(viewModel.stargazers.value.count <= 30)
    }
    
    func test_whenFetchStargazersNextPage_thenViewModelContainsMultiplePages() {
        // given
        let githubServiceMock = GithubServiceMock()
        githubServiceMock.expectation = self.expectation(description: "First page loaded")
        githubServiceMock.stargazers = Array(stargazers[0..<29])
        let viewModel = DefaultStargazersListViewModel(githubService: githubServiceMock)
        // when
        viewModel.fetchFirstPage(
            repoOwner: "owner",
            repoName: "name"
        )
        //then
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewModel.currentPage, 1)
        
        // when
        githubServiceMock.expectation = self.expectation(description: "Second page loaded")
        githubServiceMock.stargazers = stargazers
        
        viewModel.fetchNextPage()
        
        // then
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertTrue(viewModel.stargazers.value.count > 30)
    }
    
    func test_whenRemovingAllStargazers_thenViewModelContainsNoStargazers() {
        // given
        let githubServiceMock = GithubServiceMock()
        githubServiceMock.expectation = self.expectation(description: "First page loaded")
        githubServiceMock.stargazers = Array(stargazers[0..<29])
        let viewModel = DefaultStargazersListViewModel(githubService: githubServiceMock)
        // when
        viewModel.fetchFirstPage(
            repoOwner: "owner",
            repoName: "name"
        )
        //then
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewModel.currentPage, 1)
        
        // when
        githubServiceMock.stargazers = []
        
        viewModel.clearStargazers()
        
        // then
        XCTAssertEqual(viewModel.currentPage, 0)
        XCTAssertEqual(viewModel.stargazers.value.count, 0)
    }
    
    func test_whenFetchStargazersReturnsError_thenViewModelContainsError() {
        // given
        let githubServiceMock = GithubServiceMock()
        githubServiceMock.expectation = self.expectation(description: "First page loaded")
        githubServiceMock.error = .fetchFailed(statusCode: 404, networkError: .error(statusCode: 404, data: nil))
        let viewModel = DefaultStargazersListViewModel(githubService: githubServiceMock)
        // when
        viewModel.fetchFirstPage(
            repoOwner: "owner",
            repoName: "name"
        )
        
        //then
        waitForExpectations(timeout: 5)
        XCTAssertNotNil(githubServiceMock.error, githubServiceMock.error!.localizedDescription)
    }
    
    func test_whenFetchStargazersNextPageReturnsError_thenViewModelContainsError() {
        let githubServiceMock = GithubServiceMock()
        githubServiceMock.expectation = self.expectation(description: "First page loaded")
        githubServiceMock.stargazers = Array(stargazers[0..<29])
        let viewModel = DefaultStargazersListViewModel(githubService: githubServiceMock)
        // when
        viewModel.fetchFirstPage(
            repoOwner: "owner",
            repoName: "name"
        )
        //then
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewModel.currentPage, 1)
        
        //when
        githubServiceMock.expectation = self.expectation(description: "First page loaded")
        githubServiceMock.error = .fetchFailed(statusCode: 404, networkError: .error(statusCode: 404, data: nil))
        
        viewModel.fetchNextPage()
        
        //then
        waitForExpectations(timeout: 5)
        XCTAssertNotNil(githubServiceMock.error)
    }
}
