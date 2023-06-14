//
//  MockDetailPagePresenter.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 15.06.2023.
//

import Foundation
import CoreData
@testable import SearchTunes


final class MockDetailPagePresenter: DetailViewPresenterProtocol {
    
    var viewDidLoadCalled = false
    var addToFavoritesCalled = false
    var discardFavoriteCalled = false
    var favoriteButtonTappedCalled = false
    var playButtonTappedCalled = false
    var getIsFavoriteCalled = false
    var changeSliderActionCalled = false
    var viewWillDisappearCalled = false
    var changeFavoriteStatusCalled = false
    var getTrackCalled = false
    var forwardButtonTappedCalled = false
    var backButtonTappedCalled = false
    var setupAudioPlayerCalled = false
    
    func viewDidLoad(context: NSManagedObjectContext) {
        viewDidLoadCalled = true
    }
    
    func addToFavorites(context: NSManagedObjectContext) {
        addToFavoritesCalled = true
    }
    
    func discardFavorite(context: NSManagedObjectContext) {
        discardFavoriteCalled = true
    }
    
    func favoriteButtonTapped(context: NSManagedObjectContext) {
        favoriteButtonTappedCalled = true
    }
    
    func playButtonTapped() {
        playButtonTappedCalled = true
    }
    
    func getIsFavorite() -> Bool {
        getIsFavoriteCalled = true
        return false // Replace with your desired mock value
    }
    
    func changeSliderAction() {
        changeSliderActionCalled = true
    }
    
    func viewWillDisappear() {
        viewWillDisappearCalled = true
    }
    
    func changeFavoriteStatus(status: Bool) {
        changeFavoriteStatusCalled = true
    }
    
    func getTrack() -> SearchTunes.Track? {
        getTrackCalled = true
        return nil // Replace with your desired mock value
    }
    
    func forwardButtonTapped() {
        forwardButtonTappedCalled = true
    }
    
    func backButtonTapped() {
        backButtonTappedCalled = true
    }
    
    func setupAudioPlayer() {
        setupAudioPlayerCalled = true
    }
}

