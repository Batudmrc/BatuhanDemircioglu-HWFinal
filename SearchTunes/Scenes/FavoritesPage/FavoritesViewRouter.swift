//
//  FavoritesViewRouter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation

protocol FavoritesViewRouterProtocol {
    
}

final class FavoritesViewRouter: FavoritesViewRouterProtocol {
    weak var viewController: FavoritesViewController?
    
    static func createModule() -> FavoritesViewController {
        let view = FavoritesViewController()
        let router = FavoritesViewRouter()
        let presenter = FavoritesViewPresenter(view: view, router: router)
        view.presenter = presenter
        router.viewController = view
        return view
    }
}

