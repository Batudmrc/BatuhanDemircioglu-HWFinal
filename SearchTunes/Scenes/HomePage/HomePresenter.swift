//
//  HomePresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import Foundation

protocol HomePresenterProtocol {
    var numberOfItems: Int { get }
    
    func load()
    func track(_ index: Int) -> Track?
    func didSelectRowAt(_ index: Int)
}

final class HomePresenter {
    
    private var tracks: [Track] = []
    weak var view: HomeViewControllerProtocol?
    private let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol?
    
    init(
        view: HomeViewControllerProtocol?,
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {
    func didSelectRowAt(_ index: Int) {
        
    }
    
    func load() {
        view?.showLoading()
        view?.setupTableView()
        interactor.fetchTracks()
    }
    
    func track(_ index: Int) -> Track? {
        tracks[index]
    }
    
    var numberOfItems: Int {
        tracks.count
    }
}

extension HomePresenter: HomeInteractorOutput {
    
    func handleTrackResult(_ result: Result<SearchResult, Error>) {
        view?.hideLoading()
        switch result {
        case .success(let tracks):
            self.tracks = tracks.results!
            view?.reloadData()
        case .failure(let failure):
            //TODO: showError
            print(failure)
        }
    }
}
