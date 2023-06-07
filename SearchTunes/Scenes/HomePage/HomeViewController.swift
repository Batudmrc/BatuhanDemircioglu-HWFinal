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
    func showLoading()
    func hideLoading()
    func reloadData()
}

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let service: NetworkManagerProtocol = NetworkManager()
    
    let spinner = UIActivityIndicatorView(style: .large)
    var spinnerBackgroundView: UIView = UIView()
    
    var presenter: HomePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupTableView()
        presenter.load()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.identifier, for: indexPath) as! HomePageTableViewCell
        cell.coverImageView.image = nil
        if let track = presenter.track(indexPath.row) {
            cell.trackName.text = track.trackName
            cell.artistName.text = track.artistName
            cell.collectionName.text = track.collectionName
            
            //cell.configute(model: <#T##HomeCellConfigureModel#>)
            
            let imageURL = URL(string: track.artworkUrl100!)
            
            // Show the spinner
            cell.spinner.startAnimating()
            cell.spinner.isHidden = false
            
            // Start the image download operation
            service.downloadImage(fromURL: imageURL!) { image in
                // Hide the spinner
                DispatchQueue.main.async {
                    cell.spinner.stopAnimating()
                    cell.spinner.isHidden = true
                    
                    // Animate the image appearing
                    cell.coverImageView.alpha = 0.0
                    cell.coverImageView.image = image
                    UIView.animate(withDuration: 0.3) {
                        cell.coverImageView.alpha = 1.0
                    }
                }
                
            }
        }
        return cell
    }
}

extension HomeViewController: HomeViewControllerProtocol, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextDidChange(searchText)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: HomePageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomePageTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
}

