//
//  DetailViewRouter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation

protocol DetailViewRouterProtocol {
    
}

final class DetailViewRouter: DetailViewRouterProtocol {
    
    weak var viewController: DetailViewController?
    
    static func createModule() -> DetailViewController {
        let view = DetailViewController()
        let router = DetailViewRouter()
        let interactor = DetailViewInteractor(view: view)
        let presenter = DetailViewPresenter(view: view, router: router, interactor: interactor)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
