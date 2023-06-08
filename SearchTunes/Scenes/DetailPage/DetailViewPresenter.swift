//
//  DetailViewPresenter.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import Foundation
import NetworkPackage
import CoreData

protocol DetailViewPresenterProtocol {
    
    func viewDidLoad(context: NSManagedObjectContext)
    func addToFavorites(context: NSManagedObjectContext)
    func discardFavorite(context: NSManagedObjectContext)
    func favoriteButtonTapped(context: NSManagedObjectContext)
    func getIsFavorite() -> Bool
}

final class DetailViewPresenter {
    
    private let service: NetworkManagerProtocol = NetworkManager()
    
    unowned var view: DetailViewControllerProtocol!
    let router: DetailViewRouterProtocol!
    private var isFavorite = false
    var favoriteTracks = [Item]()
    
    init(view: DetailViewControllerProtocol!, router: DetailViewRouterProtocol!) {
        self.view = view
        self.router = router
    }
}

extension DetailViewPresenter: DetailViewPresenterProtocol {
    
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

    
        func viewDidLoad(context: NSManagedObjectContext) {
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
    //TODO: add to the coreData
    func addToFavorites(context: NSManagedObjectContext) {
        isFavorite = true
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
        }
        
    }
    //TODO: remove from coreData
    func discardFavorite(context: NSManagedObjectContext) {
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
        }
    }




}
