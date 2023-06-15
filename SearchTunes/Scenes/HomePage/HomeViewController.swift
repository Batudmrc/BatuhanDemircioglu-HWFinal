//
//  ViewController.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 5.06.2023.
//

import UIKit
import NetworkPackage

protocol HomeViewControllerProtocol: AnyObject {
    func setupTableView()
    func reloadData()
    func setupEmptyView()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let service: NetworkManagerProtocol = NetworkManager()
    
    var presenter: HomePresenterProtocol!
    let interactor: HomePageTableViewCellInteractorProtocol = HomePageTableViewCellInteractor()
    let messageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccesIdentifiers()
        setupUI()
    }
    
    func setAccesIdentifiers() {
        searchBar.searchTextField.accessibilityIdentifier = "searchTextField"
        tableView.accessibilityIdentifier = "tableView"
    }
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemIndigo.cgColor,  // Top color (light gray)
            UIColor.darkGray.cgColor    // Bottom color (darker gray)
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.2)
        gradientLayer.frame = UIScreen.main.bounds  // Set the frame based on the screen's bounds
        topView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        presenter.favoriteButtonTapped()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isEmpty = presenter.numberOfItems == 0
        UIView.animate(withDuration: 0.8) {
            self.messageLabel.alpha = isEmpty ? 1.0 : 0.0
        }
        return isEmpty ? 0 : presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.identifier, for: indexPath) as! HomePageTableViewCell
        cell.coverImageView.image = nil
        if let track = presenter.track(indexPath.row) {
            let presenter = HomePageTableViewCellPresenter(
                view: cell,
                tracks: track,
                interactor: interactor
            )
            cell.homeViewController = self
            cell.cellPresenter = presenter
            cell.spinner.startAnimating()
            cell.spinner.isHidden = false
        }
        return cell
    }
}

extension HomeViewController: HomeViewControllerProtocol, UISearchBarDelegate {
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextDidChange(searchText)
    }
    
    
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let range = NSRange(location: 0, length: self.tableView.numberOfSections)
            let sections = IndexSet(integersIn: Range(range) ?? 0..<0)
            // Set the desired animation option for the reload
            let animationOptions: UITableView.RowAnimation = .fade
            // Perform the animated reload
            let isEmpty = self.presenter.numberOfItems == 0
            self.messageLabel.isHidden = !isEmpty
            self.tableView.reloadSections(sections, with: animationOptions)
        }
    }
}

