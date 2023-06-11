//
//  HomePresenterTests.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import XCTest
@testable import SearchTunes

class HomePresenterTests: XCTestCase {
    var presenter: HomePresenter!
    var mockView: MockHomeViewController!
    var mockInteractor: MockHomeInteractor!
    var mockRouter: MockHomeRouter!
    
    // Initialize
    override func setUp() {
        super.setUp()
        
        mockView = .init()
        mockInteractor = .init()
        mockRouter = .init()
        presenter = .init(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    // Deinitialize
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testSearchBarTextDidChange() {
        // Given
        let searchText = "test"
        
        // Functions below are not called before user made a change in the textfield
        XCTAssertFalse(mockView.showLoadingCalled, "showLoading should be called")
        XCTAssertFalse(mockView.setupTableViewCalled, "setupTableView should be called")
        XCTAssertFalse(mockView.setupEmptyViewCalled, "setupEmptyView should be called")
        
        // When
        presenter.searchBarTextDidChange(searchText)
        
        // Then
        XCTAssertTrue(mockView.showLoadingCalled, "showLoading should be called")
        XCTAssertTrue(mockView.setupTableViewCalled, "setupTableView should be called")
        XCTAssertTrue(mockView.setupEmptyViewCalled, "setupEmptyView should be called")
        
        mockInteractor.fetchTracks(with: searchText)
        XCTAssertTrue(mockInteractor.fetchTracksCalled, "fetchTracks should be called")
        XCTAssertEqual(mockInteractor.fetchTracksSearchText, searchText, "fetchTracks should be called with correct searchText")
    }
    
    func testExample() {
        
        
        mockInteractor.fetchTracks(with: "Ezhel")
        XCTAssertTrue(mockInteractor.fetchTracksCalled)
        
    }
    
    func testFetchTracksOutput() {

        
        presenter.handleTrackResult(.success(.response))
        
        XCTAssertEqual(presenter.numberOfItems, 1)
    }
}

extension SearchResult {
    
    static var response: SearchResult {
        let bundle = Bundle(for: HomePresenterTests.self)
        let path = bundle.path(forResource: "Tracks", ofType: "json")
        let file = try! String(contentsOfFile: path!)
        let data = file.data(using: .utf8)
        let response = try! JSONDecoder().decode(SearchResult.self, from: data!)
        return response
    }
}



