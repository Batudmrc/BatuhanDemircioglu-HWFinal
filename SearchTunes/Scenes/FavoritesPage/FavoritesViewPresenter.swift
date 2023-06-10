//
//  FavoritesViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import CoreData
import UIKit

protocol FavoritesViewPresenterProtocol: AnyObject {
    func fetchFavorites()
    func numberOfFavorites() -> Int
    func favorite(at index: Int) -> Item?
}

final class FavoritesViewPresenter {
    unowned var view: FavoritesViewControllerProtocol!
    let router: FavoritesViewRouterProtocol!
    private var favorites: [Item] = []
    
    init(view: FavoritesViewControllerProtocol!, router: FavoritesViewRouterProtocol!) {
        self.view = view
        self.router = router
    }
}

extension FavoritesViewPresenter: FavoritesViewPresenterProtocol {
    func fetchFavorites() {
        // Fetch favorites from Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
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
