//
//  HighlightCell.swift
//  Week-4
//
//  Created by Kerim Caglar on 10.07.2021.
//

import UIKit

class HighlightCell: UICollectionViewCell, EDevletCellProtocol {
    
    static var reuseIdentifier: String = "HighlightCell"
    
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label
        name.numberOfLines = 0
        
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel
        
        //imageView hugging
        
        let innerStackView = UIStackView(arrangedSubviews: [name, subtitle])
        innerStackView.axis = .vertical
        
        let outerStackView = UIStackView(arrangedSubviews: [imageView,innerStackView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.spacing = 10
        contentView.addSubview(outerStackView)
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with edevlet: EDevlet?) {
        name.text = edevlet?.name
        subtitle.text = edevlet?.subheading
        imageView.image = UIImage(named: edevlet?.image ?? "e-devlet_logo")
    }
    
    
}
