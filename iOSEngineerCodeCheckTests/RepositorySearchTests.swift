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
    private(set) var showUIActivityIndicatorViewCallCount = 0
    private(set) var hideUIActivityIndicatorViewCallCount = 0
    private(set) var tapTableRowCellCallCount = 0
    private(set) var selectedRepository: Repository?
    
    func didStartToFetch() {
        showUIActivityIndicatorViewCallCount += 1
    }
    
    func didFetch(_ repositories: [Repository]) {
        hideUIActivityIndicatorViewCallCount += 1
    }
    
    func didFailToFetchRepository(with error: Error) {
        hideUIActivityIndicatorViewCallCount += 1
    }
    
    func didFetchRepository(of repository: Repository) {
        tapTableRowCellCallCount += 1
        selectedRepository = repository
        print("repo", repository)
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
    var spy: RepositorySearchPresenterOutputSpy!
    var stub: GitHubAPIModelInputStub!
    var presenter: RepositorySearchPresenter!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        spy = RepositorySearchPresenterOutputSpy()
        stub = GitHubAPIModelInputStub()
        presenter = RepositorySearchPresenter(with: spy, with: stub)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDidTapSearchButtonFetchSuccess() {
        XCTContext.runActivity(named: "検索ボタンをタップしたときActivityIndicatorが呼び出されているか") { _ in
            XCTContext.runActivity(named: "APIRequestがsuccessのとき") { _ in
                // Before tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCallCount, 0)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCallCount, 0)
                
                let mockRepository = Repository(id: 1, url: "https://github.com", fullName: "iOSTest", owner: RepositoryOwner(id: 1, avatarURL: "https://via.placeholder.com/150"), language: "Swift", starCount: 10, watchersCount: 10, forksCount: 20, openIssuesCount: 30)
                stub.mockResponse(response: .success([mockRepository]))
                presenter.searchBarSearchButtonClicked(searchWord: "Apple")
                
                // After tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCallCount, 1)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCallCount, 1)
            }
        }
    }
    
    func testDidTapSearchButtonFetchFailure() {
        XCTContext.runActivity(named: "検索ボタンをタップしたときActivityIndicatorが呼び出されているか") { _ in
            XCTContext.runActivity(named: "APIRequestがfailureのとき") { _ in
                // Before tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCallCount, 0)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCallCount, 0)
                
                stub.mockResponse(response: .failure(APIError.network))
                presenter.searchBarSearchButtonClicked(searchWord: "Apple")
                
                // After tapping search button
                XCTAssertEqual(spy.showUIActivityIndicatorViewCallCount, 1)
                XCTAssertEqual(spy.hideUIActivityIndicatorViewCallCount, 1)
            }
        }
    }
    
    func testDidTapCellRowFetchSuccess() {
        XCTContext.runActivity(named: "TableViewのcellをタップしたときにそのレポジトリが取得できているか") { _ in
            XCTContext.runActivity(named: "APIRequestがsuccessのとき") { _ in
                
                // Before tapping cell
                XCTAssertEqual(spy.tapTableRowCellCallCount, 0)
                
                let mockRepository1 = Repository(id: 1, url: "https://github.com", fullName: "iOSTest", owner: RepositoryOwner(id: 1, avatarURL: "https://via.placeholder.com/150"), language: "Swift", starCount: 10, watchersCount: 10, forksCount: 20, openIssuesCount: 30)
                let mockRepository2 = Repository(id: 2, url: "https://github.com", fullName: "AppleDev", owner: RepositoryOwner(id: 2, avatarURL: "https://via.placeholder.com/150"), language: "Java", starCount: 12, watchersCount: 12, forksCount: 22, openIssuesCount: 32)
                stub.mockResponse(response: .success([mockRepository1, mockRepository2]))
                presenter.searchBarSearchButtonClicked(searchWord: "Apple")
                presenter.didSelectRowAt(row: 0)
                
                // After tapping cell
                XCTAssertEqual(spy.tapTableRowCellCallCount, 1)
                guard let selectedRepository = spy.selectedRepository else { return }
                XCTAssertEqual(selectedRepository, mockRepository1)
            }
        }
    }
    
    func testDidTapCellRowFetchFailure() {
        XCTContext.runActivity(named: "TableViewのcellをタップしたときにそのレポジトリが取得できているか") { _ in
            XCTContext.runActivity(named: "APIRequestがsuccessのとき") { _ in
                
                // Before tapping cell
                XCTAssertEqual(spy.tapTableRowCellCallCount, 0)
                
                stub.mockResponse(response: .failure(APIError.network))
                presenter.searchBarSearchButtonClicked(searchWord: "Apple")
                presenter.didSelectRowAt(row: 0)
                
                // After tapping cell
                XCTAssertEqual(spy.tapTableRowCellCallCount, 0)
                guard let _ = spy.selectedRepository
                else {
                    XCTAssertNil(spy.selectedRepository)
                    return
                }
            }
        }
    }
}

