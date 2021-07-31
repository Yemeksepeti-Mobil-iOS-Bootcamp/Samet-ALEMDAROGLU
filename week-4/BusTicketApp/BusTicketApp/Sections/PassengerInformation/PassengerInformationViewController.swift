//
//  PassengerInformationViewController.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 31.07.2021.
//

import UIKit
import CoreData

class PassengerInformationViewController: BaseViewController {

    @IBOutlet weak var contextView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    private var passenger: Passenger?
    
    var departureDate: BusDate?
    var departureClock: Clock?
    var selectedSeats: [Int]?
    
    static let identifier = "PassengerInformationViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewBackgroundColor(color: ColorConstants.primary)
        setNavigationBarTitle(title: "Passenger Information")
        configureLayout()
    }
    
    func configureLayout(){
        contextView.layer.cornerRadius = 5
        
        completeButton.layer.cornerRadius = 5
        completeButton.backgroundColor = ColorConstants.secondary
        completeButton.tintColor = .white
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        if nameTextField.text?.isEmpty ?? true || surnameTextField.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
            
            let actionOK = UIAlertAction(title: "Yes", style: .cancel) { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(actionOK)
            present(alertController, animated: true, completion: nil)
        } else {
            passenger = Passenger(id: UUID(), name: nameTextField.text ?? "", surname: surnameTextField.text ?? "")
            createTicket()
        }
    }
    
    private func createTicket() {
        
        guard let passenger = passenger else {
            return
        }
        
        guard let departureDate = departureDate else {
            return
        }
        
        guard let departureClock = departureClock else {
            return
        }
        
        guard let seats = selectedSeats else {
            return
        }
        
        insertPassenger()
        
        let ticket = Ticket(passenger: passenger, date: departureDate, clock: departureClock, seats: seats)
        
        insertTicket(ticket: ticket)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let VC = storyBoard.instantiateViewController(withIdentifier: TicketDetailViewController.identifier) as? TicketDetailViewController else {
            return
        }
        
        VC.ticket = ticket
        
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func insertPassenger(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
        let context = appDelegate.persistentContainer.viewContext
        
        let newTicket = NSEntityDescription.insertNewObject(forEntityName: "Passengers", into: context)
        
        guard let passenger = passenger else {
            return
        }
        
        newTicket.setValue(passenger.id, forKey: "id")
        newTicket.setValue(passenger.name, forKey: "name")
        newTicket.setValue(passenger.surname, forKey: "surname")
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func insertTicket(ticket: Ticket) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
        let context = appDelegate.persistentContainer.viewContext
        
        let newTicket = NSEntityDescription.insertNewObject(forEntityName: "Tickets", into: context)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let dateString = "\(ticket.date.day)/\(ticket.date.month)/\(ticket.date.year) \(ticket.clock.hour):\(ticket.clock.minute)"
        
        guard let date = formatter.date(from: dateString) else {
            return
        }
        
        newTicket.setValue(UUID(), forKey: "id")
        newTicket.setValue(ticket.passenger.id, forKey: "passenger_id")
        newTicket.setValue(ticket.seats.description, forKey: "seats")
        newTicket.setValue(date, forKey: "datetime")
    
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
}
