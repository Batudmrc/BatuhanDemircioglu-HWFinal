//
//  MockHomePresenter.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import Foundation
@testable import SearchTunes

final class MockHomePresenter: HomePresenterProtocol {
    var loadCalled = false
    var trackCalled = false
    var trackIndex: Int?
    var didSelectRowAtCalled = false
    var didSelectRowAtIndex: Int?
    var favoriteButtonTappedCalled = false
    var searchBarTextDidChangeCalled = false
    var searchBarTextDidChangeSearchText: String?

    var numberOfItems: Int {
        return 0
    }

    func load() {
        loadCalled = true
    }

    func track(_ index: Int) -> Track? {
        trackCalled = true
        trackIndex = index
        return nil
    }

    func didSelectRowAt(_ index: Int) {
        didSelectRowAtCalled = true
        didSelectRowAtIndex = index
    }

    func favoriteButtonTapped() {
        favoriteButtonTappedCalled = true
    }

    func searchBarTextDidChange(_ searchText: String) {
        searchBarTextDidChangeCalled = true
        searchBarTextDidChangeSearchText = searchText
    }
}
