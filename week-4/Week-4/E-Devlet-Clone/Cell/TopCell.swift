//
//  TopCell.swift
//  Week-4
//
//  Created by Kerim Caglar on 10.07.2021.
//

import UIKit

class TopCell: UICollectionViewCell, EDevletCellProtocol {
    
    static var reuseIdentifier: String = "TopCell"
    
    let containerView = UIView()
    let imageView = UIImageView()
    let title = UILabel()
    let seperator = UIView(frame: .zero)
    
    //MARK: super init neden yaparız ne işe yarar
    // Inherit alinan sinifin init methodunu cagirir.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.backgroundColor = .red
        containerView.layer.cornerRadius = 50
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .green
        
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label
        
        let stackView = UIStackView(arrangedSubviews: [seperator, imageView, title])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = 10
        contentView.addSubview(stackView)
        
        //Autolayout config
        NSLayoutConstraint.activate([
            seperator.heightAnchor.constraint(equalToConstant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        stackView.setCustomSpacing(10, after: seperator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with edevlet: EDevlet?) {
        title.text = edevlet?.name ?? "-"
        imageView.image = UIImage(named: edevlet?.image ?? "e-devlet_logo")
    }
    
    
}
