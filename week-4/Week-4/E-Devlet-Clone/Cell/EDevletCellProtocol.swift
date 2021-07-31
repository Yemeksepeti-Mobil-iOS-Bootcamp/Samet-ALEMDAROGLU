//
//  EDevletCellProtocol.swift
//  Week-4
//
//  Created by Kerim Caglar on 10.07.2021.
//

import Foundation

protocol EDevletCellProtocol {
    static var reuseIdentifier: String { get }
    func configure(with edevlet: EDevlet?)
}
