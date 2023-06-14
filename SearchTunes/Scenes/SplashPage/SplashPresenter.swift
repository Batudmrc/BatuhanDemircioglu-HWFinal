//
//  SplashPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import Foundation

protocol SplashPresenterProtocol: AnyObject {
    func viewDidAppear()
}

final class SplashPresenter: SplashPresenterProtocol {
    
    unowned var view: SplashViewControllerProtocol!
    let router: SplashRouterProtocol
    let interactor: SplashInteractorProtocol
    
    init(
        view: SplashViewControllerProtocol!,
        router: SplashRouterProtocol,
        interactor: SplashInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidAppear() {
        interactor.checkConnection()
    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    func showNoConnectionAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.view.showNoConnectionAlert()
        }
    }
    
    func connectionStatus(status: Bool) {
        if status {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.router.navigate(.homeScreen)
            }
        } else {
            //view.noConnection()
        }
    }
    
    
}
