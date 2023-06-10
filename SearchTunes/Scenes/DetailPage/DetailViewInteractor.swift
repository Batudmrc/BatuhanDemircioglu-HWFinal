//
//  DetailViewInteractor.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import CoreData
import NetworkPackage

protocol DetailViewInteractorProtocol {
    func addToFavorites(context: NSManagedObjectContext)
    func discardFavorite(context: NSManagedObjectContext)
    func downloadImage(for track: Track, completion: @escaping (Data?) -> Void)
    func loadAudio(from url: URL, completion: @escaping (Data) -> Void)
}

protocol DetailViewInteractorOutput {
    
}

final class DetailViewInteractor {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    var favoriteTracks = [Item]()
    var presenter: DetailViewPresenterProtocol?
    var output: DetailViewInteractorOutput?
}

extension DetailViewInteractor: DetailViewInteractorProtocol {
    
    func loadAudio(from url: URL, completion: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            do {
                let audioData = try Data(contentsOf: url)
                completion(audioData)
            } catch {
                print("Failed to load audio data: \(error)")
                completion(Data())
            }
        }
    }
    
    func downloadImage(for track: Track, completion: @escaping (Data?) -> Void) {
        guard let artworkUrl = track.artworkUrl100 else {
            completion(nil)
            return
        }
        // Modify the URL make image's quality higher
        let modifiedURLString = artworkUrl.replacingOccurrences(of: "/100x100bb.jpg", with: "/640x640bb.jpg")
        let imageURL = URL(string: modifiedURLString)
        
        service.downloadImageData(fromURL: imageURL!, completion: completion)
    }

    
    func addToFavorites(context: NSManagedObjectContext) {
        
        presenter?.changeFavoriteStatus(status: true)
        guard let track = presenter!.getTrack(),
              let trackId = track.trackId else { return }
        let newFavTrack = Item(context: context)
        newFavTrack.collectionName = track.collectionName
        newFavTrack.trackName = track.trackName
        newFavTrack.previewAudio = track.previewUrl
        newFavTrack.artistName = track.artistName
        newFavTrack.trackId = String(track.trackId!)
        let imageURL = URL(string: track.artworkUrl100!)
        service.downloadImageData(fromURL: imageURL!, completion: { imageData in
            newFavTrack.coverImage = imageData
            self.favoriteTracks.append(newFavTrack)
            do {
                try context.save()
            } catch {
                print("Failed to save search history: \(error)")
            }
        })
        
        
        favoriteTracks = favoriteTracks.filter { $0.trackId != String(trackId) }
        
         let request: NSFetchRequest<Item> = Item.fetchRequest()
         do {
         favoriteTracks = try context.fetch(request)
         for i in favoriteTracks {
         print(i.coverImage as Any)
         }
         } catch {
         print(error)
         }
    }
    
    func discardFavorite(context: NSManagedObjectContext) {
        
        guard let track = presenter!.getTrack(),
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
        presenter?.changeFavoriteStatus(status: false)
        /*
         let request: NSFetchRequest<Item> = Item.fetchRequest()
         do {
         favoriteTracks = try context.fetch(request)
         for i in favoriteTracks {
         print(i.trackName as Any)
         }
         } catch {
         print(error)
         }
         */
        
    }
}
