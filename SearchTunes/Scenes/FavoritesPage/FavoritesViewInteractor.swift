//
//  FavoritesViewInteractor.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import CoreData

protocol FavoritesViewInteractorProtocol {
    func fetchFavorites(completion: @escaping (Result<[Item], Error>) -> Void)
}

final class FavoritesViewInteractor {
    var presenter: FavoritesViewPresenterProtocol?
}

extension FavoritesViewInteractor: FavoritesViewInteractorProtocol {
    func fetchFavorites(completion: @escaping (Result<[Item], Error>) -> Void) {
        let context = AppDelegate.customPersistenContainer
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let favorites = try context.fetch(fetchRequest)
            completion(.success(favorites))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
