//
//  SplashViewController.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import UIKit
import NetworkPackage

protocol SplashViewControllerProtocol: AnyObject {
    func showNoConnectionAlert()
}

final class SplashViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var presenter: SplashPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidAppear()
        spinner.startAnimating()
        // Do any additional setup after loading the view.
    }
}

extension SplashViewController: SplashViewControllerProtocol {
    
    func showNoConnectionAlert() {
        let alert = UIAlertController(title: "No Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] (_) in
            self?.presenter.viewDidAppear()
        }
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }
}
