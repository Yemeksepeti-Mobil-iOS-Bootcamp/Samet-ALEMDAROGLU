//
//  DatePickerViewController.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 31.07.2021.
//

import UIKit

class DatePickerViewController: BaseViewController {

    @IBOutlet weak var datePickerContextView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var seatSelectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewBackgroundColor(color: ColorConstants.primary)
        hideNavigationBar()
        configureLayout()
    }
    

    func configureLayout(){
        seatSelectionButton.layer.cornerRadius = 5
        seatSelectionButton.backgroundColor = ColorConstants.secondary
        seatSelectionButton.tintColor = .white
        
        datePickerContextView.layer.cornerRadius = 5
        
        datePicker.tintColor = ColorConstants.primary
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: "tr")
    }
    
    @IBAction func seatSelectionButtonTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let VC = storyBoard.instantiateViewController(withIdentifier: SeatSelectionViewController.identifier) as? SeatSelectionViewController else {
            return
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: datePicker.date)
        
        VC.departureDate = BusDate(day: components.day ?? 0, month: components.month ?? 0, year: components.year ?? 0)
        
        guard let hour = components.hour else {
            return
        }
        
        VC.departureClock = Clock(hour: hour + 3, minute: components.minute ?? 0)
        
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
}
