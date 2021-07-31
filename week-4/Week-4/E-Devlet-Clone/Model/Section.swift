//
//  Section.swift
//  Week-4
//
//  Created by Kerim Caglar on 10.07.2021.
//

import Foundation

struct Section: Decodable, Hashable {
    
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    let items: [EDevlet]
}

