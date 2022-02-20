//
//  RepositoryDetailTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Kazuki Takeda on 2022/02/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
import AlamofireImage
import XCTest
@testable import iOSEngineerCodeCheck

class RepositoryDetailPresenterOutputSpy: RepositoryDetailPresenterOutput {
    private(set) var imageFetchSuccessCallCount = 0
    private(set) var imageFetchFailureCallCount = 0
    
    func didFetch(_ imageData: Image) {
        imageFetchSuccessCallCount += 1
    }
    
    func didFailToFetchImage(with error: Error) {
        imageFetchFailureCallCount += 1
    }
}

class RepositoryDetailModelInputStub: RepositoryDetailModelInput {
    private var mockImage: Image!
    private var mockError: Error?
    
    func getImage(repository: Repository, completion: @escaping ((Result<Image, Error>) -> ())) {
        guard
            let error = mockError
        else {
            completion(.success(mockImage))
            return
        }
        completion(.failure(error))
    }
    
    func mockResponse(response: Result<Image, Error>) {
        switch response {
        case let .success(image):
            mockImage = image
        case let .failure(error):
            mockError = error
        }
    }
}

class RepositoryDetailTests: XCTestCase {
    var spy: RepositoryDetailPresenterOutputSpy!
    var stub: RepositoryDetailModelInputStub!
    var presenter: RepositoryDetailPresenter!
    var mockRepository = Repository(id: 1, url: "https://github.com", fullName: "iOSTest", owner: RepositoryOwner(id: 1, avatarURL: "https://via.placeholder.com/150"), language: "Swift", starCount: 10, watchersCount: 10, forksCount: 20, openIssuesCount: 30)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        spy = RepositoryDetailPresenterOutputSpy()
        stub = RepositoryDetailModelInputStub()
        presenter = RepositoryDetailPresenter(with: spy, with: stub)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDidImageFetchSuccess() {
        XCTContext.runActivity(named: "画像取得がsuccessのとき") { _ in
            // Before fetching image
            XCTAssertEqual(spy.imageFetchSuccessCallCount, 0)
            XCTAssertEqual(spy.imageFetchFailureCallCount, 0)
            
            let mockImage = Image(named: "mockUserImage")!
            
            stub.mockResponse(response: .success(mockImage))
            presenter.receive(mockRepository)
            
            // After fetching image
            XCTAssertEqual(spy.imageFetchSuccessCallCount, 1)
            XCTAssertEqual(spy.imageFetchFailureCallCount, 0)
        }
    }
    
    func testDidImageFetchFailure() {
        XCTContext.runActivity(named: "画像取得がfailureのとき") { _ in
            // Before fetching image
            XCTAssertEqual(spy.imageFetchSuccessCallCount, 0)
            XCTAssertEqual(spy.imageFetchFailureCallCount, 0)
            
            stub.mockResponse(response: .failure(APIError.network))
            presenter.receive(mockRepository)
            
            // After fetching image
            XCTAssertEqual(spy.imageFetchSuccessCallCount, 0)
            XCTAssertEqual(spy.imageFetchFailureCallCount, 1)
        }
    }
}
