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
    func handleTrackResult(_ result: TrackResult)
}



final class HomeInteractor {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    weak var output: HomeInteractorOutput?
}

extension HomeInteractor: HomeInteractorProtocol {
    func fetchTracks(with searchText: String) {
        service.request(.getResults(searchText: searchText)) { [weak self] result in
            guard let self = self else { return }
            self.output?.handleTrackResult(result)
        }
    }
}

typealias TrackResult = Result<SearchResult, any Error>
