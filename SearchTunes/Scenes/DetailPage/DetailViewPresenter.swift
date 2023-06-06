//
//  DetailViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import NetworkPackage

protocol DetailViewPresenterProtocol {
    func viewDidLoad()
    func addToFavorites()
    func discardFavorite()
}

final class DetailViewPresenter {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    
    unowned var view: DetailViewControllerProtocol!
    let router: DetailViewRouterProtocol!
    
    init(view: DetailViewControllerProtocol!, router: DetailViewRouterProtocol!) {
        self.view = view
        self.router = router
    }
}

extension DetailViewPresenter: DetailViewPresenterProtocol {
    func viewDidLoad() {
        guard let track = view.getTrack() else { return }
        let imageURL = URL(string: track.artworkUrl100!)
        service.downloadImage(fromURL: imageURL!, completion: { [weak self] image in
            // Use the downloaded image here
            DispatchQueue.main.async {
                self?.view.setTrackImage(image)
            }
        })
        
        view.setTrackName(track.trackName ?? "")
        view.setArtistName(track.artistName ?? "")
        view.setCollectionName(track.collectionName ?? "")

    }
    
    func addToFavorites() {
        
    }
    
    func discardFavorite() {
        
    }
    
    
}
