//
//  DetailViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import NetworkPackage
import CoreData
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
}

final class DetailViewPresenter {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    
    unowned var view: DetailViewControllerProtocol!
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
        //interactor.discardFavorite(context: )
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
        guard let track = view.getTrack(),
              let trackId = track.trackId else { return }
        
        if isFavorite {
            discardFavorite(context: context)
        } else {
            addToFavorites(context: context)
        }
        // Check if the track exists in the favoriteTracks array
        let isFavoriteTrack = favoriteTracks.contains { $0.trackId == String(trackId) }
        // Update the isFavorite flag based on whether the track is in the array
        isFavorite = isFavoriteTrack
        
        view.updateLikedButton()
    }
    
    @objc func updateSlider() {
        view.updateSlider(player?.currentTime ?? 0)
    }
    
    func viewDidLoad(context: NSManagedObjectContext) {
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        //MARK: Fetch and Check if selected track is favorite
        view.showLoading()
        guard let track = view.getTrack(),
              let trackId = track.trackId else { return }
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackId == %@", String(trackId))
        
        do {
            let matchingItems = try context.fetch(fetchRequest)
            isFavorite = !matchingItems.isEmpty
            
            view.updateLikedButton()
        } catch {
            print("Failed to fetch favorite tracks: \(error)")
        }
        
        //MARK: Download Image and Show Fetched Datas
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
        
        view.showPlayButtonLoading()
        
        //MARK: Get audio ready to play
        guard let track = view.getTrack(),
              let previewUrl = track.previewUrl,
              let audioURL = URL(string: previewUrl)
        else { return }
        DispatchQueue.global().async {
            do {
                let audioData = try Data(contentsOf: audioURL)
                DispatchQueue.main.async { [weak self] in
                    // Hide the loading animation
                    self?.view.hidePlayButtonLoading()
                    
                    // Create an AVAudioPlayer with the audio data
                    do {
                        self?.player = try AVAudioPlayer(data: audioData)
                        self!.view.setupSlider(self!.player?.duration)
                    } catch {
                        print("Failed to create AVAudioPlayer: \(error)")
                    }
                }
            } catch {
                print("Failed to load audio data: \(error)")
            }
        }
    }
    //TODO: add to the coreData
    func addToFavorites(context: NSManagedObjectContext) {
        interactor.addToFavorites(context: context)
        
        
        /*isFavorite = true
        guard let track = view.getTrack(),
              let trackId = track.trackId else { return }
        let newFavTrack = Item(context: context)
        newFavTrack.collectionName = track.collectionName
        newFavTrack.trackName = track.trackName
        newFavTrack.previewAudio = track.previewUrl
        newFavTrack.artistName = track.artistName
        newFavTrack.trackId = String(track.trackId!)
        let imageURL = URL(string: track.artworkUrl100!)
        service.downloadImage(fromURL: imageURL!, completion: { image in
            newFavTrack.coverImage = image?.pngData()
        })
        //
        favoriteTracks.append(newFavTrack)
        do {
            try context.save()
        } catch {
            print("Failed to save search history: \(error)")
        }
        favoriteTracks = favoriteTracks.filter { $0.trackId != String(trackId) }
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            favoriteTracks = try context.fetch(request)
            for i in favoriteTracks {
                print(i.trackName as Any)
            }
        } catch {
            print(error)
        }*/
    }
    //TODO: remove from coreData
    func discardFavorite(context: NSManagedObjectContext) {
        interactor.discardFavorite(context: context)
        /*
        guard let track = view.getTrack(),
              let trackId = track.trackId else { return }
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackId == %@", String(trackId))
        
        do {
            let matchingItems = try context.fetch(fetchRequest)
            for item in matchingItems {
                context.delete(item)
            }
            try context.save()
            
            // Update the favoriteTracks array by removing the discarded item
            favoriteTracks.removeAll { $0.trackId == String(trackId) }
        } catch {
            print("Failed to discard favorite: \(error)")
        }
        // Update the isFavorite flag
        isFavorite = false
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            favoriteTracks = try context.fetch(request)
            for i in favoriteTracks {
                print(i.trackName as Any)
            }
        } catch {
            print(error)
        }*/
    }
}

extension DetailViewPresenter: DetailViewInteractorOutput {
    func favoriteTracksOutput(result: [Item]) {
        favoriteTracks = result
    }
}
