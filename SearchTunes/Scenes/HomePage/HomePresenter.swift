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
    func favoriteButtonTapped()
    func searchBarTextDidChange(_ searchText: String)
}

final class HomePresenter {
    // Timer to don't make too much requests
    private var debounceInterval: TimeInterval = 0.7
    private var debounceTimer: Timer?
    
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
    func favoriteButtonTapped() {
        router?.navigateToDetail(.favorites)
    }
    
    func searchBarTextDidChange(_ searchText: String) {
        view?.showLoading()
        view?.setupTableView()
        view?.setupEmptyView()
        // Using debounceTimer to not send request too frequently
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { [weak self] _ in
            if let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                self?.interactor.fetchTracks(with: encodedText)
            }
        }
    }
    
    func didSelectRowAt(_ index: Int) {
        guard let track = track(index) else { return }
        router?.navigateToDetail(.detail(source: track))
    }
    
    func load() {
        
        //interactor.fetchTracks(with: "ezhel")
    }
    // SafeIndex koy
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
