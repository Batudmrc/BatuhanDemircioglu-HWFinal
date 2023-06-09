//
//  DetailViewInteractor.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import CoreData

protocol DetailViewInteractorProtocol {
    func addToFavorites(context: NSManagedObjectContext)
    func discardFavorite()
}

protocol DetailViewInteractorOutputProtocol {
    func fetchTrackDetailOutput(result: Track)
}

final class DetailViewInteractor: DetailViewInteractorProtocol {
    func addToFavorites(context: NSManagedObjectContext) {
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
    
    func discardFavorite() {
        
    }
    
    
}
