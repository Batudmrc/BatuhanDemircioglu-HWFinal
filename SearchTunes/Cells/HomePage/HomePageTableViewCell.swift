//
//  HomePageTableViewCell.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    static let identifier = String(describing: HomePageTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configute(model: HomeCellConfigureModel) {
        collectionName.text = model.collectionName
        artistName.text = model.artistName
        trackName.text = model.trackName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
struct HomeCellConfigureModel {
    let playerImageView: UIImageView
    let collectionName: String?
    let artistName: String?
    let trackName: String?
    let coverImageView: String?
}
