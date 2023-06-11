//
//  HomeCellTests.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import XCTest
@testable import SearchTunes

class HomePageTableViewCellTests: XCTestCase {
    
    var view: MockHomePageTableViewCell!
    var tracks: Track!
    var presenter: HomePageTableViewCellPresenter!
    var interactor: MockHomePageTableViewCellInteractor!

    
    override func setUp() {
        super.setUp()
        view = .init()
        let tracks = Track(artistName: "Ezhel", collectionName: "Müptezel", trackName: "AYA", collectionCensoredName: "erhan", artworkUrl100: "someUrl", collectionPrice: 14.99, trackPrice: 14.99, primaryGenreName: "testo", previewUrl: "someurl", wrapperType: "someurl", trackId: 214123)
        interactor = .init()
        presenter = .init(view: view,tracks: tracks, interactor: interactor)

    }
    
    override func tearDown() {
        view = nil
        interactor = nil
        presenter = nil
        super.tearDown()
    }
    // Test if Image is loaded
    func test_ImageLoaded() {
        XCTAssertFalse(interactor.loadImageCalled)
    
        presenter.load()
        
        XCTAssertTrue(interactor.loadImageCalled)
    }
    // Test if Audio is loaded
    func test_AudioLoaded() {
        
        XCTAssertFalse(interactor.loadAudioCalled)
        
        presenter.playButtonTapped()
        
        XCTAssertTrue(interactor.loadAudioCalled)
    }
}