//
//  SplashViewController.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func noConnection()
}

final class SplashViewController: UIViewController {

    var presenter: SplashPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidAppear()
        // Do any additional setup after loading the view.
    }
}

extension SplashViewController: SplashViewControllerProtocol {
    func noConnection() {
        print("Connection Yok Dayeee")
    }
}
