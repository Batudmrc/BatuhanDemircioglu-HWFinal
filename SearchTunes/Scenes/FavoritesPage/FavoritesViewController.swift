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
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let messageLabel = UILabel()
    private var emptyView: UIView!
    var presenter: FavoritesViewPresenterProtocol!
    var interactor: HomePageTableViewCellInteractorProtocol = HomePageTableViewCellInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        setupTableView()
        setupEmptyView()
        presenter.viewDidLoad()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: HomePageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomePageTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .darkGray
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
        myView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource, FavoritesViewControllerProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isEmpty = presenter.numberOfFavorites() == 0
        UIView.animate(withDuration: 0.8) {
            self.messageLabel.alpha = isEmpty ? 1.0 : 0.0
        }
        return isEmpty ? 0 : presenter.numberOfFavorites()
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
                cell.setCoverImage(imageData)
            }
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
    
    func setupEmptyView() {
        messageLabel.textAlignment = .center
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.text = "No favorite Track to display"
        tableView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
}
