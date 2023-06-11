//
//  FavoritesViewController.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import UIKit
import AVFoundation

protocol FavoritesViewControllerProtocol: AnyObject {
    
}
class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavoritesViewPresenterProtocol!
    var interactor: HomePageTableViewCellInteractorProtocol = HomePageTableViewCellInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        presenter.fetchFavorites()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: HomePageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomePageTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource, FavoritesViewControllerProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfFavorites()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.identifier, for: indexPath) as! HomePageTableViewCell
        
        
        
        if let favorite = presenter.favorite(at: indexPath.row) {
            // Configure the cell with favorite data
            cell.setCollectionName(favorite.collectionName!)
            cell.setArtistName(favorite.artistName!)
            cell.setTrackName(favorite.trackName!)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerImageViewTapped))
            cell.playerImageView.isUserInteractionEnabled = true
            cell.playerImageView.addGestureRecognizer(tapGesture)
            cell.playButtonSpinner.isHidden = true
            // Load the cover image asynchronously
            if let imageData = favorite.coverImage {
                let image = UIImage(data: imageData)
                cell.setCoverImage(image!)
            }
            let audioManager = AudioManager.shared
                    let previewUrlString = favorite.previewAudio ?? ""
                    let previewUrl = URL(string: previewUrlString)
                    let isPlaying = audioManager.isPlaying && audioManager.currentPlayingUrl == previewUrl
            cell.updatePlayButtonImageFav(isPlaying)
        }
        return cell 
    }
    
    @objc private func playerImageViewTapped(sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? UIImageView,
              let tappedCell = tappedView.superview?.superview as? HomePageTableViewCell,
              let indexPath = tableView.indexPath(for: tappedCell),
              let favorite = presenter.favorite(at: indexPath.row),
              let previewUrlString = favorite.previewAudio,
              let previewUrl = URL(string: previewUrlString) else {
            return
        }
        let audioManager = AudioManager.shared
        
        if audioManager.isPlaying, let currentPlayingUrl = audioManager.currentPlayingUrl, currentPlayingUrl == previewUrl {
            

            audioManager.pauseAudio()
        } else {
            audioManager.playAudio(from: previewUrl)
        }
    }
    
}
