//
//  Ticket.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 25.07.2021.
//

import Foundation

class Ticket {
    var passenger: Passenger
    var date: BusDate
    var clock: Clock
    var seats: [Int]
    var seatCount: Int 
    
    init(passenger: Passenger, date: BusDate, clock: Clock, seats: [Int], seatCount: Int = 0) {
        self.passenger = passenger
        self.date = date
        self.clock = clock
        self.seats = seats
        self.seatCount = seatCount
    }
    
    func compare(ticket: Ticket) -> Bool {
        for seat in seats {
            if ticket.seats.contains(seat) {
                return true
            }
        }
        return false
    }
    
    func reserveSeat(seatCount: Int){
        
        if seatCount < 1 || seatCount > 5 {
            return
        }
        
        if self.seatCount == 0 {
            self.seatCount = seatCount
            self.seats.reserveCapacity(seatCount)
        }
    }
    
    func addSeatNo(no: Int){
        if no < 1 || no > 45 {
            return
        }
        seats.append(no)
    }
    
    func print() -> String {
        
        var output = "\(passenger.print()), \(date.print()), \(clock.print()) | "
        for seat in seats {
            output.append("\(seat) ")
        }
        
        return "\(passenger.print()), \(date.print()), \(clock.print()) |"
    }
}
