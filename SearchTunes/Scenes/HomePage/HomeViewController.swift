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
        if let track = self.presenter.track(indexPath.row) {
            cell.trackName.text = track.trackName
            cell.artistName.text = track.artistName
            cell.collectionName.text = track.collectionName
            
            let imageURL = URL(string: track.artworkUrl100!)
            service.downloadImage(fromURL: imageURL!, completion: { [weak self] image in
                // Use the downloaded image here
                DispatchQueue.main.async {
                    cell.coverImageView.image = image
                }
            })
            //print("\(track.artistName) - \(track.trackName) - \(track.wrapperType)")
        }
        return cell
    }
}

extension HomeViewController: HomeViewControllerProtocol {
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

