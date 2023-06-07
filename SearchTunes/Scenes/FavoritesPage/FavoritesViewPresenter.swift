//
//  FavoritesViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation

protocol FavoritesViewPresenterProtocol: AnyObject {
    
}

final class FavoritesViewPresenter {
    unowned var view: FavoritesViewControllerProtocol!
    let router: FavoritesViewRouterProtocol!
    
    init(view: FavoritesViewControllerProtocol!, router: FavoritesViewRouterProtocol!) {
        self.view = view
        self.router = router
    }
}

extension FavoritesViewPresenter: FavoritesViewPresenterProtocol {
    
}
