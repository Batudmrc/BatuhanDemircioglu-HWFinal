//
//  DetailViewController.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import UIKit
import CoreData

protocol DetailViewControllerProtocol: AnyObject {
    func setTrackName(_ text: String)
    func setArtistName(_ text: String)
    func setCollectionName(_ text: String)
    func setTrackImage(_ image: UIImage?)
    func updateLikedButton()
    func getTrack() -> Track?
    func showLoading()
    func hideLoading()
}

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playButtonImageView: UIImageView!
    @IBOutlet weak var favoriteButtonImageView: UIImageView!
    let spinner = UIActivityIndicatorView(style: .large)
    var track: Track?
    var presenter: DetailViewPresenterProtocol!
    var favoriteTracks = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        setupImageView()
        presenter.viewDidLoad()
        //saveFavorite()
        //loadFavorite()
        
    }
    
    func saveFavorite() {
        let newHistory = Item(context: context)
        newHistory.collectionName = "abc"
        favoriteTracks.append(newHistory)
        do {
            try context.save()
        } catch {
            print("Failed to save search history: \(error)")
        }
    }
    
    func loadFavorite() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            favoriteTracks = try context.fetch(request)
            for i in favoriteTracks {
                print(i.collectionName as Any)
            }
        } catch {
            print(error)
        }
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    
    func updateLikedButton() {
        
    }
    
    func setTrackImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.coverImageView.image = image
            self.coverImageView.alpha = 0.0
            UIView.animate(withDuration: 0.35) {
                self.coverImageView.alpha = 1.0
            }
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    
    func getTrack() -> Track? {
        return track
    }
    
    func setTrackName(_ text: String) {
        trackNameLabel.text = text
    }
    
    func setArtistName(_ text: String) {
        artistNameLabel.text = text
    }
    
    func setCollectionName(_ tex: String) {
        
    }
    
    func setupImageView() {
        coverImageView.layer.cornerRadius = 8.0
        coverImageView.layer.masksToBounds = true
        coverImageView.contentMode = .scaleAspectFit
        
        // Apply shadow to the coverImageView layer
        coverImageView.layer.shadowColor = UIColor.black.cgColor
        coverImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        coverImageView.layer.shadowOpacity = 1
        coverImageView.layer.shadowRadius = 4.0
        coverImageView.layer.shadowPath = UIBezierPath(roundedRect: coverImageView.bounds, cornerRadius: coverImageView.layer.cornerRadius).cgPath
    }
    
    func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor).isActive = true
    }
    
    
}
