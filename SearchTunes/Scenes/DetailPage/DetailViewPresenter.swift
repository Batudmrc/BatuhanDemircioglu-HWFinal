//
//  DetailViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import CoreData // importing this for context NSManagedObjectContext only. All the CoreData related operations were made in interactor
import AVFoundation

protocol DetailViewPresenterProtocol {
    
    func viewDidLoad(context: NSManagedObjectContext)
    func addToFavorites(context: NSManagedObjectContext)
    func discardFavorite(context: NSManagedObjectContext)
    func favoriteButtonTapped(context: NSManagedObjectContext)
    func playButtonTapped()
    func getIsFavorite() -> Bool
    func changeSliderAction()
    func viewWillDisappear()
    func changeFavoriteStatus(status: Bool)
    func getTrack() -> Track?
    func forwardButtonTapped()
    func backButtonTapped()
    func setupAudioPlayer()
}

final class DetailViewPresenter {
    
    weak var view: DetailViewControllerProtocol!
    let router: DetailViewRouterProtocol!
    private let interactor: DetailViewInteractorProtocol
    private var isFavorite = false
    var favoriteTracks = [Item]()
    var player: AVAudioPlayer?
    private var timer: Timer?
    
    init(view: DetailViewControllerProtocol!, router: DetailViewRouterProtocol!, interactor: DetailViewInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension DetailViewPresenter: DetailViewPresenterProtocol {
    func setupAudioPlayer() {
        if let player = player {
            view?.hidePlayButtonLoading()
            view?.setupSlider(player.duration)
        }
    }
    
    func forwardButtonTapped() {
        guard let currentTime = player?.currentTime else { return }
        let newTime = currentTime + 5.0
        player?.currentTime = newTime
        view.updateSlider(newTime)
    }
    
    func backButtonTapped() {
        guard let currentTime = player?.currentTime else { return }
        let newTime = max(currentTime - 5.0, 0.0)
        player?.currentTime = newTime
        view.updateSlider(newTime)
    }
    
    func getTrack() -> Track? {
        view.getTrack()
    }
    
    func changeFavoriteStatus(status: Bool) {
        DispatchQueue.main.async {
            self.isFavorite = status
            self.view.updateLikedButton()
        }
    }
    
    func viewWillDisappear() {
        timer?.invalidate()
        player?.stop()
    }
    
    func changeSliderAction() {
        player?.stop()
        player?.currentTime = TimeInterval(view.changeSliderAction())
        player?.prepareToPlay()
        view.updatePlayButtonImage("play.circle.fill")
    }
    
    func playButtonTapped() {
        if player?.isPlaying == true {
            player?.pause()
            view.updatePlayButtonImage("play.circle.fill")
            
        } else {
            player?.play()
            view.updatePlayButtonImage("pause.circle.fill")
        }
    }
    
    func getIsFavorite() -> Bool {
        return isFavorite
    }
    
    func favoriteButtonTapped(context: NSManagedObjectContext) {
        if isFavorite {
            view.showDiscardAlert {
                self.discardFavorite(context: context)
            }
        } else {
            addToFavorites(context: context)
        }
    }
    
    @objc func updateSlider() {
        view.updateSlider(player?.currentTime ?? 0)
    }
    
    func viewDidLoad(context: NSManagedObjectContext) {
        
        guard let track = view.getTrack(),
              let trackId = track.trackId else { return }
        // Check if the track exists in the favoriteTracks array
        let isFavoriteTrack = favoriteTracks.contains { $0.trackId == String(trackId) }
        // Update the isFavorite flag based on whether the track is in the array
        isFavorite = isFavoriteTrack
        
        view.updateLikedButton()
        // Create a timer that updates slider every 0.1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        view.showLoading()
        //MARK: Fetch and Check if selected track is favorite
        interactor.fetchFavoriteTracks(context: context, for: track) { [weak self] matchingItems in
            DispatchQueue.main.async {
                let isFavorite = !matchingItems.isEmpty
                self?.changeFavoriteStatus(status: isFavorite) // Update the isFavorite flag
            }
        }
        
        //MARK: Download Image and Show Fetched Datas
        interactor.downloadImage(for: track) { [weak self] imageData in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.view?.setTrackImage(imageData)
                self.view?.hideLoading()
            }
        }
        view.setTrackName(track.trackName ?? "")
        view.setArtistName(track.artistName ?? "")
        view.setCollectionName(track.collectionName ?? "")
        
        view.showPlayButtonLoading()
        
        //MARK: Get audio ready to play
        guard let previewUrl = track.previewUrl, let audioURL = URL(string: previewUrl) else { return }
        interactor.loadAudio(from: audioURL) { [weak self] audioData in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                guard let view = self.view else {
                    return
                }
                view.hidePlayButtonLoading()
                do {
                    self.player = try AVAudioPlayer(data: audioData)
                    self.setupAudioPlayer()
                } catch {
                    print("Failed to create AVAudioPlayer: \(error)")
                }
            }
        }
    }
    //TODO: add to the coreData
    func addToFavorites(context: NSManagedObjectContext) {
        interactor.addToFavorites(context: context)
    }
    //TODO: remove from coreData
    func discardFavorite(context: NSManagedObjectContext) {
        interactor.discardFavorite(context: context)
    }
}

extension DetailViewPresenter: DetailViewInteractorOutput {
    func favoriteTracksOutput(result: [Item]) {
        favoriteTracks = result
    }
}
