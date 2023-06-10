//
//  HomePageTableViewCell.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import UIKit
import AVFoundation

protocol HomePageTableViewCellProtocol: AnyObject {
    func setCoverImage(_ image: UIImage)
    func setPlayerImage(_ image:UIImage)
    func setCollectionName(_ text: String)
    func setArtistName(_ text: String)
    func setTrackName(_ text: String)
    func setPrice(_ text: String?)
    func updatePlayButtonImage(_ imageName: String)
    func updatePlayButtonImageFav(_ isPlaying: Bool)
    func showPlayButtonLoading()
    func hidePlayButtonLoading()
}

class HomePageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UIButton!
    @IBOutlet weak var playButtonSpinner: UIActivityIndicatorView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    weak var homeViewController: HomeViewController?
    static let identifier = String(describing: HomePageTableViewCell.self)
    
    var audioPlayer: AVAudioPlayer?
    
    var cellPresenter: HomePageTableViewCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.alpha = 0.0
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: []) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }
        
        setupGesture()
    }
    @objc private func playerImageViewTapped() {
        
        cellPresenter.playButtonTapped()
    }
    
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playerImageViewTapped))
        playerImageView.isUserInteractionEnabled = true
        playerImageView.addGestureRecognizer(tapGesture)
        playButtonSpinner.isHidden = true
    }
}

extension HomePageTableViewCell: HomePageTableViewCellProtocol {
    func updatePlayButtonImageFav(_ isPlaying: Bool) {
        let image = isPlaying ? UIImage(systemName: "pause.circle.fill") : UIImage(systemName: "play.circle.fill")
            // Set the image to your play button image view
            playerImageView.image = image
    }
    
    
    func updatePlayButtonImage(_ imageName: String) {
        let scaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.transition(with: playerImageView, duration: 0.12, options: [.transitionCrossDissolve], animations: {
            self.playerImageView.transform = scaleTransform
            self.playerImageView.image = UIImage(systemName: imageName)
        }) { _ in
            UIView.animate(withDuration: 0.12) {
                self.playerImageView.transform = .identity
            }
        }
    }
    
    func setPrice(_ text: String?) {
        priceLabel.setTitle(text, for: .normal)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        audioPlayer?.stop()
    }

    
    func showPlayButtonLoading() {
        playButtonSpinner.startAnimating()
    }
    
    func hidePlayButtonLoading() {
        playButtonSpinner.stopAnimating()
        playButtonSpinner.isHidden = true
    }
    
    func setCollectionName(_ text: String) {
        collectionName.text = text
    }
    
    func setCoverImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.coverImageView.image = image
        }
    }
    
    func setPlayerImage(_ image: UIImage) {
        
    }
    
    func setArtistName(_ text: String) {
        artistName.text = text
    }
    
    func setTrackName(_ text: String) {
        trackName.text = text
    }
    
    
}

