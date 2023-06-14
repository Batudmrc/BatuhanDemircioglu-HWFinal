//
//  MockDetailPageInteractor.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 15.06.2023.
//

import Foundation
import CoreData
@testable import SearchTunes


final class MockDetailPageInteractor: DetailViewInteractorProtocol {
    
    var addToFavoritesCalled = false
    var discardFavoriteCalled = false
    var downloadImageCalled = false
    var loadAudioCalled = false
    var fetchFavoriteTracksCalled = false
    
    func addToFavorites(context: NSManagedObjectContext) {
        addToFavoritesCalled = true
    }
    
    func discardFavorite(context: NSManagedObjectContext) {
        discardFavoriteCalled = true
    }
    
    func downloadImage(for track: SearchTunes.Track, completion: @escaping (Data?) -> Void) {
        // Mock implementation for downloading image
        let mockImageData = Data() // Replace with your mock image data
        completion(mockImageData)
        downloadImageCalled = true
    }
    
    func loadAudio(from url: URL, completion: @escaping (Data) -> Void) {
        // Mock implementation for loading audio data
        let mockAudioData = Data() // Replace with your mock audio data
        completion(mockAudioData)
        loadAudioCalled = true
    }
    
    func fetchFavoriteTracks(context: NSManagedObjectContext, for track: SearchTunes.Track, completion: @escaping ([SearchTunes.Item]) -> Void) {
        // Mock implementation for fetching favorite tracks
        let mockFavoriteTracks: [SearchTunes.Item] = [] // Replace with your mock favorite tracks
        completion(mockFavoriteTracks)
        fetchFavoriteTracksCalled = true
    }
    
}
