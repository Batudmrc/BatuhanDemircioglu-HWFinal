//
//  HomePageTableViewCell.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import UIKit

protocol HomePageTableViewCellProtocol: AnyObject {
    func setCoverImage(_ image: UIImage)
    func setPlayerImage(_ image:UIImage)
    func setCollectionName(_ text: String)
    func setArtistName(_ text: String)
    func setTrackName(_ text: String)
}

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    static let identifier = String(describing: HomePageTableViewCell.self)
    
    var cellPresenter: HomePageTableViewCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension HomePageTableViewCell: HomePageTableViewCellProtocol {
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

