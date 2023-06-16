//
//  DetailViewController.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    func setTrackName(_ text: String)
    func setArtistName(_ text: String)
    func setCollectionName(_ text: String)
    func setPrice(_ text: String?)
    func setTrackImage(_ imageData: Data?)
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
    func showDiscardAlert(completion: (() -> Void)?)
}

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var shareButtonImageView: UIImageView!
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var forwardButton: UIImageView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
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
        setAccesIdentifiers()
        setupUI()
        presenter.viewDidLoad(context: context)
    }
    
    func setupUI() {
        setupSpinner()
        setupGesture()
        setupImageViews()
    }
    
    func setAccesIdentifiers() {
        playButtonImageView.accessibilityIdentifier = "playButton"
        favoriteButtonImageView.accessibilityIdentifier = "favoriteButton"
        elapsedTimeLabel.accessibilityIdentifier = "elapsedTimeLabel"
        remainingTimeLabel.accessibilityIdentifier = "remainingTimeLabel"
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        presenter.changeSliderAction()
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    
    func showDiscardAlert(completion: (() -> Void)?) {
        let alertController = UIAlertController(
            title: "Discard Favorite",
            message: "Are you sure you want to discard this favorite?",
            preferredStyle: .alert
        )
        
        let discardAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            completion?()
        }
        alertController.addAction(discardAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setPrice(_ text: String?) {
        priceButton.setTitle(text, for: .normal)
    }
    
    func changeSliderAction() -> Float {
        musicSlider.value
    }
    
    func setupSlider(_ duration: TimeInterval?) {
        musicSlider.maximumValue = Float(duration!)
    }
    
    func updateSlider(_ currentTime: TimeInterval?) {
        musicSlider.value = Float(currentTime ?? 0)
        let elapsedSeconds = Int(currentTime ?? 0)
        let elapsedMinutes = elapsedSeconds / 60
        let elapsedSecondsRemainder = elapsedSeconds % 60
        
        // Calculate remaining time
        let remainingSeconds = Int(30) - elapsedSeconds
        let remainingMinutes = remainingSeconds / 60
        let remainingSecondsRemainder = remainingSeconds % 60
        
        
        UIView.transition(with: elapsedTimeLabel, duration: 0.12, options: .transitionCrossDissolve, animations: {
            self.elapsedTimeLabel.text = String(format: "%02d:%02d", elapsedMinutes, elapsedSecondsRemainder)
        }, completion: nil)
        
        UIView.transition(with: remainingTimeLabel, duration: 0.12, options: .transitionCrossDissolve, animations: {
            self.remainingTimeLabel.text = String(format: "-%02d:%02d", remainingMinutes, remainingSecondsRemainder)
        }, completion: nil)
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
        self.playButtonImageView.alpha = 0.0
        self.playButtonSpinner.alpha = 1.0
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.playButtonSpinner.alpha = 0.0
                self?.playButtonImageView.alpha = 1.0
            }) { _ in
                self?.playButtonSpinner.stopAnimating()
                self?.playButtonSpinner.alpha = 0.0
                self?.playButtonImageView.image = UIImage(systemName: "play.circle.fill")
            }
        }
    }
    
    //MARK: Gesture functions
    @objc func shareButtonTapped() {
        guard let url = URL(string: (track?.trackViewUrl)!) else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        DispatchQueue.main.async {
            activityViewController.popoverPresentationController?.sourceView = self.view
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func playButtonTapped() {
        presenter.playButtonTapped()
    }
    
    @objc func favoriteButtonTapped() {
        presenter.favoriteButtonTapped(context: context)
    }
    
    @objc func forwardButtonTapped() {
        presenter.forwardButtonTapped()
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    func updateLikedButton() {
        let isFavorite = presenter.getIsFavorite()
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        DispatchQueue.main.async {
            if isFavorite {
                self.favoriteButtonImageView.tintColor = .red
            } else {
                self.favoriteButtonImageView.tintColor = .white
            }
            UIView.transition(with: self.favoriteButtonImageView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.favoriteButtonImageView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
                self.favoriteButtonImageView.image = image
                self.favoriteButtonImageView.transform = .identity
            }, completion: nil)
        }
    }
    // Turning image Data to UIImage
    func setTrackImage(_ imageData: Data?) {
        if let imageData = imageData {
            if let image = UIImage(data: imageData) {
                UIView.transition(with: coverImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.coverImageView.image = image
                    self.setGradient(image: image)
                }, completion: nil)
            } else {
                
            }
        } else {
            
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
}



