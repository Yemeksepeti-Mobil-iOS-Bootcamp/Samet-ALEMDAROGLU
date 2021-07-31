//
//  GameCollectionViewCell.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 19.07.2021.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet private var contextView: UIView!
    @IBOutlet private var gameImageView: UIImageView!
    @IBOutlet private var gameNameLabel: UILabel!
    @IBOutlet private var gameReleaseDateLabel: UILabel!
    @IBOutlet private var gameRatingLabel: UILabel!
    
    static let cellID = "GameCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLayout()
    }

    private func configureLayout(){
        contextView.layer.shadowColor = UIColor.black.cgColor
        contextView.layer.shadowOpacity = 0.5
        contextView.layer.shadowOffset = CGSize(width: 10, height: 5)
        contextView.layer.shadowRadius = 5
    }
    
    func configureCell(imageUrl: String?, name: String?, releasedDate: String?, rate: String?){
        
        if let imageUrl = imageUrl {
            gameImageView.kf.setImage(with: URL(string: imageUrl))
        }
        
        gameNameLabel.text = name
        
        if let releasedDate = releasedDate {
            gameReleaseDateLabel.text = "Release Date: \(releasedDate.dateToTRFormat())"
        }
        
        if let rate = rate {
            gameRatingLabel.text = "Rate: \(rate)"
        }
        
    }
}
