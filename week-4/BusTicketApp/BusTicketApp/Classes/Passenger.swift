//
//  Passenger.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 25.07.2021.
//

import Foundation

class Passenger {
    var id: UUID?
    var name: String = "Anonymous"
    var surname: String = "Anonymous"
    
    init(id: UUID, name: String, surname: String) {
        self.id = id
        self.name = name
        self.surname = surname
    }
    
    func print() -> String {
        return "\(name) \(surname)"
    }
}
