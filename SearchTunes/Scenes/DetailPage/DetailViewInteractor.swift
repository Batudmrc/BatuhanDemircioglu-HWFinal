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
}

protocol DetailViewInteractorOutput {
    func favoriteTracksOutput(result: [Item])
}

final class DetailViewInteractor {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    var favoriteTracks = [Item]()
    weak var view: DetailViewControllerProtocol?
    var presenter: DetailViewPresenterProtocol?
    var output: DetailViewInteractorOutput?
    
    init(
        view: DetailViewControllerProtocol?
    ) {
        self.view = view
    }
}

extension DetailViewInteractor: DetailViewInteractorProtocol {
    
    func addToFavorites(context: NSManagedObjectContext) {
        
        presenter?.changeFavoriteStatus(status: true)
        guard let track = view!.getTrack(),
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
        //output?.favoriteTracksOutput(result: favoriteTracks)
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
    
    func discardFavorite(context: NSManagedObjectContext) {

        guard let track = view!.getTrack(),
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
