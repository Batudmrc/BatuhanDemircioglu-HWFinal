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
    func fetchTracks()
}

protocol HomeInteractorOutput: AnyObject {
    func handleTrackResult(_ result: Result<SearchResult, any Error>)
}

//TODO: Bunu sonradan ayarla
typealias TrackResult = Result<SearchResult, any Error>

final class HomeInteractor {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    weak var output: HomeInteractorOutput?
    
    /*init(service: NetworkManagerProtocol) {
        self.service = service
    }*/
    
}

extension HomeInteractor: HomeInteractorProtocol {
    func fetchTracks() {
        service.request(.getResults(searchText: "Recep+tayyip+erdogan"), completion: { [weak self] (result: Result<SearchResult, Error>) in
            guard self != nil else { return }
            self?.output?.handleTrackResult(result)
        })
    }
    
    
}
