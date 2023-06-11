//
//  MockHomeInteractor.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import Foundation
@testable import SearchTunes


final class MockHomeInteractor: HomeInteractorProtocol {
    var fetchTracksCalled = false
    var fetchTracksSearchText: String?
    var fetchTracksClosure: ((String) -> Void)?
    var output: HomeInteractorOutput?

    func fetchTracks(with searchText: String) {
        fetchTracksCalled = true
        fetchTracksSearchText = searchText
        fetchTracksClosure?(searchText)
    }
}
