//
//  DetailPagePresenterTests.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 15.06.2023.
//

import XCTest
import CoreData
import AVFoundation
@testable import SearchTunes

class DetailViewPresenterTests: XCTestCase {
    
    var presenter: DetailViewPresenter!
    var mockView: MockDetailPageController!
    var mockRouter: MockDetailPageRouter!
    var mockInteractor: MockDetailPageInteractor!
    
    override func setUp() {
        super.setUp()
        mockView = MockDetailPageController()
        mockRouter = MockDetailPageRouter()
        mockInteractor = MockDetailPageInteractor()
        
        presenter = DetailViewPresenter(view: mockView, router: mockRouter, interactor: mockInteractor)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testAddToFavorites() {
        // Given
        let mockContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // When
        presenter.addToFavorites(context: mockContext)
        // Then
        XCTAssertTrue(mockInteractor.addToFavoritesCalled)
    }
    
    func testDiscardFavorite() {
        // Given
        let mockContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // When
        presenter.discardFavorite(context: mockContext)
        
        // Then
        XCTAssertTrue(mockInteractor.discardFavoriteCalled)
        // Add more assertions as needed
    }
    
}
