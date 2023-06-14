//
//  FavoritesViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation

protocol FavoritesViewPresenterProtocol: AnyObject {
    func numberOfFavorites() -> Int
    func favorite(at index: Int) -> Item?
    func viewDidLoad()
}

final class FavoritesViewPresenter {
    unowned var view: FavoritesViewControllerProtocol!
    let router: FavoritesViewRouterProtocol!
    private var favorites: [Item] = []
    private let interactor: FavoritesViewInteractorProtocol!
    
    init(view: FavoritesViewControllerProtocol!, router: FavoritesViewRouterProtocol!, interactor: FavoritesViewInteractorProtocol!) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension FavoritesViewPresenter: FavoritesViewPresenterProtocol {
    func viewDidLoad() {
        interactor.fetchFavorites { [weak self] result in
            switch result {
            case .success(let favorites):
                self?.favorites = favorites
            case .failure(let error):
                // Handle the error
                print("Failed to fetch favorites: \(error)")
            }
        }
    }
    
    func numberOfFavorites() -> Int {
        return favorites.count
    }
    
    func favorite(at index: Int) -> Item? {
        guard index >= 0 && index < favorites.count else {
            return nil
        }
        return favorites[index]
    }
}
