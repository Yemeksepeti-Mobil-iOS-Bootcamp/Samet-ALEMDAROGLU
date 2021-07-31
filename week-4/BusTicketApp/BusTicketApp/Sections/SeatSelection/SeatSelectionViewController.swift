//
//  ViewController.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 23.07.2021.
//

import UIKit
import CoreData

class SeatSelectionViewController: BaseViewController {

    @IBOutlet weak var busView: UIView!
    @IBOutlet weak var busSeatCollectionView: UICollectionView!
    @IBOutlet weak var busSteeringImageView: UIImageView!
    @IBOutlet weak var busExitImageView: UIImageView!
    
    @IBOutlet weak var bookedSeatImageView: UIImageView!
    @IBOutlet weak var selectedSeatImageView: UIImageView!
    @IBOutlet weak var emptySeatImageView: UIImageView!
    @IBOutlet weak var selectedSeatCountLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    private var seats: [Int] = []
    private var selectedSeats: [Int] = []
    private var bookedSeats: [Int] = []
    
    var departureDate: BusDate?
    var departureClock: Clock?
    
    static let identifier = "SeatSelectionViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNavigationBar()
        setNavigationBarTitle(title: "Select Seat")
        configureLayout()
        configureCollectionView()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBookedSeats()
    }
    
    private func configureLayout(){
        
        busSteeringImageView.leadingAnchor.constraint(equalTo: busView.leadingAnchor, constant: busSeatCollectionView.frame.width / 6 - (busSteeringImageView.frame.width / 2)).isActive = true
        
        busExitImageView.trailingAnchor.constraint(equalTo: busSeatCollectionView.trailingAnchor, constant: -(busSeatCollectionView.frame.width / 6 - (busExitImageView.frame.width / 2))).isActive = true

        bookedSeatImageView.setImageColor(color: ColorConstants.primary)
        selectedSeatImageView.setImageColor(color: ColorConstants.secondary)
        emptySeatImageView.setImageColor(color: ColorConstants.gray)
        
        busSteeringImageView.setImageColor(color: ColorConstants.gray)
        busExitImageView.setImageColor(color: ColorConstants.gray)
        
        busView.layer.borderWidth = 1
        busView.layer.borderColor = UIColor.rgba(red: 200, green: 200, blue: 200, alpha: 1).cgColor
        
        continueButton.backgroundColor = ColorConstants.secondary
        continueButton.tintColor = .white
        continueButton.layer.cornerRadius = 5
    }
    
    private func configureCollectionView(){
        busSeatCollectionView.delegate = self
        busSeatCollectionView.dataSource = self

        busSeatCollectionView.register(SeatCollectionViewCell.nib, forCellWithReuseIdentifier: SeatCollectionViewCell.identifier)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let VC = storyBoard.instantiateViewController(withIdentifier: PassengerInformationViewController.identifier) as? PassengerInformationViewController else {
            return
        }
        
        VC.departureDate = departureDate
        VC.departureClock = departureClock
        VC.selectedSeats = selectedSeats
        
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func bindData(){
        
        for seatNo in 1...45 {
            seats.append(seatNo)
        }
        busSeatCollectionView.reloadData()
    }
    
    private func fetchBookedSeats() {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    
        let context = appDelegate.persistentContainer.viewContext
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tickets")
        
        var bookedSeats: [Int] = []
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
          
                if let seats = result.value(forKey: "seats") as? String {
                    
                    let resultSeats = seats.trimmingCharacters(in: CharacterSet(charactersIn: "[]")).components(separatedBy:", ").map {
                        Int($0) ?? 0
                    }
                   
                    bookedSeats.append(contentsOf: resultSeats)
                }
            }
            
            self.bookedSeats = bookedSeats
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

extension SeatSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatCollectionViewCell.identifier, for: indexPath) as? SeatCollectionViewCell else {
           
            return UICollectionViewCell()
        }

        if selectedSeats.contains(indexPath.row){
            cell.seatImageView.setImageColor(color: ColorConstants.secondary)
        }else if bookedSeats.contains(indexPath.row){
            cell.seatImageView.setImageColor(color: ColorConstants.primary)
        } else {
            cell.seatImageView.setImageColor(color: ColorConstants.gray)
        }
        
        
        
        let seat = seats[indexPath.row]
        
        cell.configureCell(seatNo: seat)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 3, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if selectedSeats.count == 5 && !selectedSeats.contains(indexPath.row){
            
            let alertController = UIAlertController(title: "Seat Not Selected", message: "A maximum of 5 seats can be selected", preferredStyle: .alert)
            let alertOK = UIAlertAction(title: "Yes", style: .cancel) { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertOK)
            present(alertController, animated: true, completion: nil)
            
            return false
        } else if bookedSeats.contains(indexPath.row) {
            
            let alertController = UIAlertController(title: "Seat Not Selected", message: "Booked seat can not be selected", preferredStyle: .alert)
            let alertOK = UIAlertAction(title: "Yes", style: .cancel) { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertOK)
            present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !selectedSeats.contains(indexPath.row){
            selectedSeats.append(indexPath.row)
            busSeatCollectionView.reloadData()
        }else{
            selectedSeats = selectedSeats.filter { $0 != indexPath.row }
            busSeatCollectionView.reloadData()
        }
        
        selectedSeatCountLabel.text = "\(selectedSeats.count)"
    }
}

