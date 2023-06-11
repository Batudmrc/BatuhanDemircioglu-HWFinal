//
//  MockHomePageTableViewCellInteractor.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import Foundation
@testable import SearchTunes

class MockHomePageTableViewCellInteractor: HomePageTableViewCellInteractorProtocol {
    var loadImageCalled = false
    var loadAudioCalled = false
    
    func loadImage(for track: Track, completion: @escaping (Data?) -> Void) {
        loadImageCalled = true

    }
    
    func loadAudio(from url: URL, completion: @escaping (Data) -> Void) {
        loadAudioCalled = true

    }
}

