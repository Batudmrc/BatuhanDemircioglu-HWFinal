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
    func setTrackImage(_ image: UIImage?)
    func getTrack() -> Track?
}

final class DetailViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playButtonImageView: UIImageView!
    @IBOutlet weak var favoriteButtonImageView: UIImageView!
    var track: Track?
    var presenter: DetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
    }

}

extension DetailViewController: DetailViewControllerProtocol {
    func setTrackImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.coverImageView.image = image
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
