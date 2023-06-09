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
    func setupGesture()
    func showPlayButtonLoading()
    func hidePlayButtonLoading()
    func updatePlayButtonImage(_ imageName: String)
    func updateSlider(_ currentTime: TimeInterval?)
    func setupSlider(_ duration: TimeInterval?)
    func changeSliderAction() -> Float
}

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playButtonImageView: UIImageView!
    @IBOutlet weak var favoriteButtonImageView: UIImageView!
    let spinner = UIActivityIndicatorView(style: .large)
    let playButtonSpinner = UIActivityIndicatorView(style: .large)
    var track: Track?
    var presenter: DetailViewPresenterProtocol!
    var favoriteTracks = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.viewWillDisappear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
        setupGesture()
        setupImageView()
        presenter.viewDidLoad(context: context)
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
    
    @IBAction func sliderAction(_ sender: Any) {
        presenter.changeSliderAction()
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
    func changeSliderAction() -> Float {
        musicSlider.value
    }
    
    func setupSlider(_ duration: TimeInterval?) {
        musicSlider.maximumValue = Float(duration!)
    }
    
    func updateSlider(_ currentTime: TimeInterval?) {
        musicSlider.value = Float(currentTime ?? 0)
    }
    
    func updatePlayButtonImage(_ imageName: String) {
        let scaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.transition(with: playButtonImageView, duration: 0.12, options: [.transitionCrossDissolve], animations: {
            self.playButtonImageView.transform = scaleTransform
            self.playButtonImageView.image = UIImage(systemName: imageName)
        }) { _ in
            UIView.animate(withDuration: 0.12) {
                self.playButtonImageView.transform = .identity
            }
        }
    }
    
    func showPlayButtonLoading() {
        playButtonImageView.image = nil
        DispatchQueue.main.async {
            self.playButtonSpinner.startAnimating()
        }
    }
    
    func hidePlayButtonLoading() {
        DispatchQueue.main.async { [weak self] in
            UIView.transition(with: (self?.playButtonImageView)!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self?.playButtonSpinner.stopAnimating()
                self?.playButtonImageView.image = UIImage(systemName: "play.circle.fill")
            }, completion: nil)
        }
    }
    
    func setupGesture() {
        let tapFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        favoriteButtonImageView.isUserInteractionEnabled = true
        favoriteButtonImageView.addGestureRecognizer(tapFavoriteGesture)
        
        let tapPlayGesture = UITapGestureRecognizer(target: self, action: #selector(playButtonTapped))
        playButtonImageView.isUserInteractionEnabled = true
        playButtonImageView.addGestureRecognizer(tapPlayGesture)
    }
    
    @objc func playButtonTapped() {
        presenter.playButtonTapped()
    }
    
    @objc func favoriteButtonTapped() {
        presenter.favoriteButtonTapped(context: context)
    }
    
    
    func updateLikedButton() {
        let isFavorite = presenter.getIsFavorite()
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        
        if isFavorite {
            favoriteButtonImageView.tintColor = .red
        } else {
            favoriteButtonImageView.tintColor = .darkGray
        }
        
        UIView.transition(with: favoriteButtonImageView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.favoriteButtonImageView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            self.favoriteButtonImageView.image = image
            self.favoriteButtonImageView.transform = .identity
        }, completion: nil)
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
        coverImageView.layer.shadowColor = UIColor.clear.cgColor
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
        
        playButtonSpinner.translatesAutoresizingMaskIntoConstraints = false
        playButtonImageView.addSubview(playButtonSpinner)
        playButtonSpinner.centerXAnchor.constraint(equalTo: playButtonImageView.centerXAnchor).isActive = true
        playButtonSpinner.centerYAnchor.constraint(equalTo: playButtonImageView.centerYAnchor).isActive = true
    }
}
