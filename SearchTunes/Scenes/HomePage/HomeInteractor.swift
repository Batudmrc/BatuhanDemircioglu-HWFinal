//
//  HomeInteractor.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import Foundation
import NetworkPackage

//MARK: Presenter -> InteractorProtocol
protocol HomeInteractorProtocol {
    func fetchTracks(with searchText: String)
}

protocol HomeInteractorOutput: AnyObject {
    func handleTrackResult(_ result: Result<SearchResult, any Error>)
}

//TODO: Bunu sonradan ayarla
typealias TrackResult = Result<SearchResult, any Error>

final class HomeInteractor {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    weak var output: HomeInteractorOutput?
    
}

extension HomeInteractor: HomeInteractorProtocol {
    func fetchTracks(with searchText: String) {
        service.request(.getResults(searchText: searchText), completion: { [weak self] (result: Result<SearchResult, Error>) in
            guard self != nil else { return }
            self?.output?.handleTrackResult(result)
        })
    }
}
