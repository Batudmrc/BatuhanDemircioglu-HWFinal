//
//  SplashRouter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import UIKit

enum SplashRoutes {
    case homeScreen
}

protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}

final class SplashRouter: SplashRouterProtocol {
    weak var viewController: SplashViewController?
    
    static func createModule() -> SplashViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        let presenter = SplashPresenter(view: view, router: router, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
    
    func navigate(_ route: SplashRoutes) {
        switch route {
        case .homeScreen:
            guard let window = viewController?.view.window else { return }
            let homeVC = HomeRouter.createModule()
            // Apply crossfade animation
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.fade
            window.layer.add(transition, forKey: kCATransition)
            
            let navigationController = UINavigationController(rootViewController: homeVC!)
            window.rootViewController = navigationController
        }
    }
    
    
}
