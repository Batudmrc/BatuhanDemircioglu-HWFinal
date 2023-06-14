//
//  MockDetailPageController.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 15.06.2023.
//

import Foundation
@testable import SearchTunes

final class MockDetailPageController: DetailViewControllerProtocol {
    
    var setTrackNameCalled = false
    var setArtistNameCalled = false
    var setCollectionNameCalled = false
    var setPriceCalled = false
    var setTrackImageCalled = false
    var updateLikedButtonCalled = false
    var getTrackCalled = false
    var setupSliderCalled = false
    
    
    func setTrackName(_ text: String) {
        setTrackNameCalled = true
    }
    
    func setArtistName(_ text: String) {
        setArtistNameCalled = true
    }
    
    func setCollectionName(_ text: String) {
        
    }
    
    func setPrice(_ text: String?) {
        
    }
    
    func setTrackImage(_ imageData: Data?) {
        setTrackImageCalled = true
    }
    
    func updateLikedButton() {
        updateLikedButtonCalled = true
    }
    
    func getTrack() -> SearchTunes.Track? {
        return Track(artistName: "", collectionName: "", trackName: "", collectionCensoredName: "", artworkUrl100: "", collectionPrice: 2, trackPrice: 2, primaryGenreName: "", previewUrl: "", wrapperType: "", trackId: 5, kind: "", trackViewUrl: "")
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func setupGesture() {
        
    }
    
    func showPlayButtonLoading() {
        
    }
    
    func hidePlayButtonLoading() {
        
    }
    
    func updatePlayButtonImage(_ imageName: String) {
        
    }
    
    func updateSlider(_ currentTime: TimeInterval?) {
        
    }
    
    func setupSlider(_ duration: TimeInterval?) {
        setupSliderCalled = true
    }
    
    func changeSliderAction() -> Float {
        return 0.0
    }
    
    func showDiscardAlert(completion: (() -> Void)?) {
        
    }

    
    
    
    
}
