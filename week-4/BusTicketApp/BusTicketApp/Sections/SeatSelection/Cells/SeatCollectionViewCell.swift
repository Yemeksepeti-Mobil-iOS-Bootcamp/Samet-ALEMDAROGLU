//
//  SeatCollectionViewCell.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 28.07.2021.
//

import UIKit

class SeatCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var seatNoLabel: UILabel!
    @IBOutlet weak var seatImageView: UIImageView!
    
    static let nib = UINib(nibName: "SeatCollectionViewCell", bundle: nil)
    static let identifier = "SeatCollectionViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configureCell(seatNo: Int) {
        seatNoLabel.text = "\(seatNo)"
    }
        
}
