//
//  HomeRouter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import UIKit

protocol HomeRouterProtocol {
    func navigateToDetail()
}

final class HomeRouter {
    weak var navigationController: UINavigationController?
    private weak var homeVC: HomeViewController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    static func createModule() -> HomeViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        view?.presenter = presenter
        interactor.output = presenter
        return view
        
    }
}

extension HomeRouter: HomeRouterProtocol {
    func navigateToDetail() {
        
    }
    
    
}
