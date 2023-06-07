//
//  HomePageTableViewCellPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import NetworkPackage
import UIKit

protocol HomePageTableViewCellPresenterProtocol {
    func load()
}

final class HomePageTableViewCellPresenter {
    weak var view: HomePageTableViewCell?
    private let tracks: Track
    
    private let service: NetworkManagerProtocol = NetworkManager()
    
    init(
        view: HomePageTableViewCellProtocol? = nil,
        tracks: Track
    ) {
        self.view = (view as! HomePageTableViewCell)
        self.tracks = tracks
    }
}

extension HomePageTableViewCellPresenter: HomePageTableViewCellPresenterProtocol {
    func load() {
        guard (tracks.artworkUrl100 != nil) else { return }
        guard (tracks.collectionName != nil) else { return }
        guard (tracks.trackName != nil) else { return }
        guard (tracks.artistName != nil) else { return }
        let imageURL = URL(string: tracks.artworkUrl100!)
        service.downloadImage(fromURL: imageURL!) { image in
            DispatchQueue.main.async {
                self.view?.spinner.isHidden = true
                // Animate the image appearing
                self.view!.coverImageView.alpha = 0.0
                self.view?.setCoverImage(image!)
                UIView.animate(withDuration: 0.3) {
                    self.view!.coverImageView.alpha = 1.0
                }
                self.view?.setTrackName(self.tracks.trackName!)
                self.view?.setArtistName(self.tracks.artistName!)
                self.view?.setCollectionName(self.tracks.collectionName!)
                
            }
        }
        
    }
}
