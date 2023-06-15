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
    
    // Mock Objects
    let imageData = Data()
    let track = Track(artistName: "", collectionName: "", trackName: "", collectionCensoredName: "", artworkUrl100: "", collectionPrice: 1.0, trackPrice: 1.0, primaryGenreName: "", previewUrl: "", wrapperType: "", trackId: 2, kind: "", trackViewUrl: "")
    let mockAudioUrl = URL(string: "someUrl")
    let mockAudioData = Data()
    
    override func setUp() {
        super.setUp()
        mockView = .init()
        mockRouter = .init()
        mockInteractor = .init()
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
        
        XCTAssertFalse(mockInteractor.addToFavoritesCalled)
        // When
        presenter.addToFavorites(context: mockContext)
        // Then
        XCTAssertTrue(mockInteractor.addToFavoritesCalled)
    }
    
    func testDiscardFavorite() {
        // Given
        let mockContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        XCTAssertFalse(mockInteractor.discardFavoriteCalled)
        // When
        presenter.discardFavorite(context: mockContext)
        // Then
        XCTAssertTrue(mockInteractor.discardFavoriteCalled)
    }
    
    func testDownloadImage() {
        XCTAssertFalse(mockInteractor.downloadImageCalled)
        
        mockInteractor.downloadImage(for: track) { data in
            XCTAssertEqual(data, self.imageData)
        }
        
        XCTAssertTrue(mockInteractor.downloadImageCalled)
    }
    
    func testLoadAudio() {
        XCTAssertFalse(mockInteractor.loadAudioCalled)
        
        mockInteractor.loadAudio(from: mockAudioUrl!) { audioData in
            XCTAssertEqual(audioData, self.mockAudioData)
        }
        
        XCTAssertTrue(mockInteractor.loadAudioCalled)
    }
}
