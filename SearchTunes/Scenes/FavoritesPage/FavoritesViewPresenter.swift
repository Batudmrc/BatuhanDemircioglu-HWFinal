//
//  FavoritesViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import CoreData

protocol FavoritesViewPresenterProtocol: AnyObject {
    func fetchFavorites()
    func numberOfFavorites() -> Int
    func favorite(at index: Int) -> Item?
    func viewDidLoad()
}

final class FavoritesViewPresenter {
    unowned var view: FavoritesViewControllerProtocol!
    let router: FavoritesViewRouterProtocol!
    private var favorites: [Item] = []
    //private let interactor: FavoritesViewInteractorProtocol
    
    init(view: FavoritesViewControllerProtocol!, router: FavoritesViewRouterProtocol!) {
        self.view = view
        self.router = router
    }
}

extension FavoritesViewPresenter: FavoritesViewPresenterProtocol {
    func viewDidLoad() {
        fetchFavorites()
    }
    func fetchFavorites() {
        // Fetch favorites from Core Data
        let context = AppDelegate.customPersistenContainer
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            favorites = try context.fetch(fetchRequest)
            //view?.reloadData()
        } catch {
            print("Failed to fetch favorites: \(error)")
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
