//
//  HomePageCellInteractor.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 9.06.2023.
//

import Foundation
import NetworkPackage

protocol HomePageTableViewCellInteractorProtocol {
    func loadImage(for track: Track, completion: @escaping (Data?) -> Void)
    func loadAudio(from url: URL, completion: @escaping (Data) -> Void)
}

final class HomePageTableViewCellInteractor {
    private let service: NetworkManagerProtocol = NetworkManager()
}

extension HomePageTableViewCellInteractor: HomePageTableViewCellInteractorProtocol {
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
    
    func loadImage(for track: Track, completion: @escaping (Data?) -> Void) {
        guard let artworkUrl = track.artworkUrl100 else {
            completion(nil)
            return
        }
        
        let modifiedURLString = artworkUrl.replacingOccurrences(of: "/100x100bb.jpg", with: "/640x640bb.jpg")
        let imageURL = URL(string: modifiedURLString)
        
        service.downloadImageData(fromURL: imageURL!, completion: completion)
    }
}
