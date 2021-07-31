//
//  Date.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 25.07.2021.
//

import Foundation

class BusDate {
    var day: Int = 1
    var month: Int = 1
    var year: Int = 2021
    
    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
    
    func print() -> String {
        return "\(day)/\(month)/\(year)"
    }
}
