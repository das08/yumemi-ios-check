//
//  RepositorySearchTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Kazuki Takeda on 2022/02/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class RepositorySearchPresenterOutputSpy: RepositorySearchPresenterOutput {
    private(set) var showUIActivityIndicatorViewCount = 0
    private(set) var hideUIActivityIndicatorViewCount = 0
    
    func didStartToFetch() {
        showUIActivityIndicatorViewCount += 1
    }
    
    func didFetch(_ repositories: [Repository]) {
        hideUIActivityIndicatorViewCount += 1
    }
    
    func didFailToFetchRepository(with error: Error) {
        hideUIActivityIndicatorViewCount += 1
    }
    
    func didFetchRepository(of repository: Repository) {
        
    }
    
    func didBeginEditing() {
        
    }
}

class GitHubAPIModelInputStub: GitHubAPIModelInput {
    private var mockRepositories: [Repository] = []
    private var mockError: Error?
    
    func fetchRepositories(searchWord: String, completion: @escaping ((Result<[Repository], Error>) -> ())) {
        guard
            let error = mockError
        else {
            completion(.success(mockRepositories))
            return
        }
        completion(.failure(error))
    }
    
    func mockResponse(response: Result<[Repository], Error>) {
        switch response {
        case let .success(repositories):
            mockRepositories = repositories
        case let .failure(error):
            mockError = error
        }
    }
}

class RepositorySearchTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDidTapSearchButton() {
        XCTContext.runActivity(named: "検索ボタンをクリックしたときActivityIndicatorが呼び出されているか") { _ in
            XCTContext.runActivity(named: "検索結果がsuccessのとき") { _ in
                let spy = RepositorySearchPresenterOutputSpy()
                let stub = GitHubAPIModelInputStub()
                let presenter = RepositorySearchPresenter(with: spy, with: stub)
                
                // Before tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCount, 0)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCount, 0)
                
                let mockRepository = Repository(id: 1, url: "https://github.com", fullName: "iOSTest", owner: RepositoryOwner(id: 1, avatarURL: "https://via.placeholder.com/150"), language: "Swift", starCount: 10, watchersCount: 10, forksCount: 20, openIssuesCount: 30)
                stub.mockResponse(response: .success([mockRepository]))
                presenter.searchBarSearchButtonClicked(searchWord: "Apple")
                
                // After tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCount, 1)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCount, 1)
            }
            
            XCTContext.runActivity(named: "検索結果がfailureのとき") { _ in
                let spy = RepositorySearchPresenterOutputSpy()
                let stub = GitHubAPIModelInputStub()
                let presenter = RepositorySearchPresenter(with: spy, with: stub)
                
                // Before tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCount, 0)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCount, 0)
                
                stub.mockResponse(response: .failure(APIError.network))
                presenter.searchBarSearchButtonClicked(searchWord: "Apple")
                
                // After tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCount, 1)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCount, 1)
            }
        }
    }
    
}

