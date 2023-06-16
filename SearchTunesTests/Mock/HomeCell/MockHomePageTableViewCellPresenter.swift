//
//  MockHomePageTableViewCellPresenter.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import Foundation
@testable import SearchTunes


final class MockHomePageTableViewCellPresenter: HomePageTableViewCellPresenterProtocol {
    var loadCalled = false
    var playButtonTappedCalled = false
    var setCoverImageCalled = false
    
    func setArtistName(_ text: String) {
        
    }
    var setTrackNameCalled = false
    func setTrackName(_ text: String) {
        setTrackNameCalled = true
    }   
    
    func setCollectionName(_ text: String) {
        
    }
    
    func load() {
        setCoverImageCalled = true
        loadCalled = true
    }
    
    func playButtonTapped() {
        playButtonTappedCalled = true
    }
    
    
}
