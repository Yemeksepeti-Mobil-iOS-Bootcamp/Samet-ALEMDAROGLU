//
//  Clock.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 25.07.2021.
//

import Foundation

class Clock {
    var hour: Int = 0
    var minute: Int = 0
    
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    func print() -> String {
        return "\(hour):\(minute)"
    }
}
