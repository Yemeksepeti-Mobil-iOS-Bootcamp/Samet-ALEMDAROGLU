//
//  TicketDetailViewController.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 31.07.2021.
//

import UIKit
import CoreData

class TicketDetailViewController: BaseViewController{


    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    
    static let identifier = "TicketDetailViewController"
    
    var ticket: Ticket?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarTitle(title: "Ticket Detail")
        setViewBackgroundColor(color: ColorConstants.primary)
        hideBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let ticket = ticket else {
            return
        }
        
        fullNameLabel.text = ticket.passenger.print()
        dateLabel.text = "\(ticket.date.print()) \(ticket.clock.print())"
        
        ticket.seats.sort {
            $0 < $1
        }
        
        for seat in ticket.seats {
            seatsLabel.text?.append("\(seat), ")
        }
        seatsLabel.text?.removeLast(2)
    }
    
    
    
}
