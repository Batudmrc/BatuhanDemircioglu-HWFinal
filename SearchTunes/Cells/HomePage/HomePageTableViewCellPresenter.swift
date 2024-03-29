//
//  HomePageTableViewCellPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import AVFoundation

protocol HomePageTableViewCellPresenterProtocol {
    func load()
    func playButtonTapped()
    func setArtistName(_ text: String)
    func setTrackName(_ text: String)
    func setCollectionName(_ text: String)
}

final class HomePageTableViewCellPresenter {
    weak var view: HomePageTableViewCell?
    private let tracks: Track
    var audioPlayer: AVAudioPlayer?
    private let interactor: HomePageTableViewCellInteractorProtocol
    
    init(
        view: HomePageTableViewCellProtocol? = nil,
        tracks: Track,
        interactor: HomePageTableViewCellInteractorProtocol
    ) {
        self.view = (view as? HomePageTableViewCell)
        self.tracks = tracks
        self.interactor = interactor
    }
}

extension HomePageTableViewCellPresenter: HomePageTableViewCellPresenterProtocol {
    
    func setCollectionName(_ text: String) {
        view?.setCollectionName(text)
    }
    
    func setArtistName(_ text: String) {
        view?.setArtistName(text)
    }
    
    func setTrackName(_ text: String) {
        view?.setTrackName(text)
    }
    
    func playButtonTapped() {
        guard let previewUrl = tracks.previewUrl, let audioURL = URL(string: previewUrl) else { return }
        
        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                view?.updatePlayButtonImage("play.circle.fill")
            } else {
                player.play()
                view?.updatePlayButtonImage("pause.circle.fill")
            }
        } else {
            interactor.loadAudio(from: audioURL) { [weak self] audioData in
                DispatchQueue.main.async {
                    do {
                        let player = try AVAudioPlayer(data: audioData)
                        player.play()
                        self?.audioPlayer = player
                        self?.view?.updatePlayButtonImage("pause.circle.fill")
                    } catch {
                        print("Failed to create AVAudioPlayer: \(error)")
                    }
                }
            }
        }
    }
    
    func load() {
        guard (tracks.artworkUrl100 != nil) else { return }
        guard (tracks.collectionName != nil) else { return }
        guard (tracks.trackName != nil) else { return }
        guard (tracks.artistName != nil) else { return }
        guard (tracks.trackPrice != nil) else { return }
        guard URL(string: tracks.artworkUrl100 ?? "") != nil else {
            return
        }
        interactor.loadImage(for: tracks) { [weak self] imageData in
            DispatchQueue.main.async {
                self?.view?.spinner.isHidden = true
                if let imageData = imageData {
                    // Animate the image appearing
                    self?.view?.coverImageView.alpha = 0.0
                    self?.view?.setCoverImage(imageData)
                    
                }
            }
        }
        setTrackName(self.tracks.trackName!)
        setArtistName(self.tracks.artistName!)
        setCollectionName(self.tracks.collectionName!)
        if let trackPrice = self.tracks.trackPrice {
            self.view?.setPrice("$\(String(trackPrice))")
        } else {
            self.view?.setPrice(nil)
        }
    }
}



