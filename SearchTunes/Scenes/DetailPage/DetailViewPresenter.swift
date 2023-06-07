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
        view.showLoading()
        guard let track = view.getTrack() else { return }
        let modifiedURLString = track.artworkUrl100!.replacingOccurrences(of: "/100x100bb.jpg", with: "/320x320bb.jpg")
        let imageURL = URL(string: modifiedURLString)
        service.downloadImage(fromURL: imageURL!, completion: { [weak self] image in
            // Use the downloaded image here
            DispatchQueue.main.async {
                self?.view.setTrackImage(image)
                self!.view.hideLoading()
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
