//
//  MockHomePageTableViewCell.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import Foundation
import UIKit
@testable import SearchTunes

class MockHomePageTableViewCell: HomePageTableViewCellProtocol {
    
    var setPlayerImageCalled = false
    var setCollectionNameCalled = false
    var setTrackNameCalled = false
    var setPriceCalled = false
    var updatePlayButtonImageCalled = false
    var updatePlayButtonImageFavCalled = false
    var showPlayButtonLoadingCalled = false
    var hidePlayButtonLoadingCalled = false
    
    
    var setCoverImageCalled = false
    var setCoverImageParameters: (image: UIImage, Void)?
    func setCoverImage(_ image: Data) {
        setCoverImageCalled = true
        let photo = UIImage(data: image)
        setCoverImageParameters = (photo!, ())
    }
    
    func setPlayerImage(_ image: UIImage) {
        setPlayerImageCalled = true
    }
    
    func setCollectionName(_ text: String) {
        setCollectionNameCalled = true
    }
    
    var setArtistNameCalled = false
    var setArtistNameParameters: (text: String, Void)?
    func setArtistName(_ text: String) {
        setArtistNameCalled = true
        setArtistNameParameters = (text, ())
    }
    
    func setTrackName(_ text: String) {
        setTrackNameCalled = true
    }
    
    func setPrice(_ text: String?) {
        setPriceCalled = true
    }
    
    func updatePlayButtonImage(_ imageName: String) {
        updatePlayButtonImageCalled = true
    }
    
    func updatePlayButtonImageFav(_ isPlaying: Bool) {
        updatePlayButtonImageFavCalled = true
    }
    
    func showPlayButtonLoading() {
        showPlayButtonLoadingCalled = true
    }
    
    func hidePlayButtonLoading() {
        hidePlayButtonLoadingCalled = true
    }
}
