//
//  GameDetailViewController.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 16.07.2021.
//

import UIKit
import CoreData
import Kingfisher

class GameDetailViewController: UIViewController {

    @IBOutlet private var gameImageView: UIImageView!
    @IBOutlet private var gameNameLabel: UILabel!
    @IBOutlet private var gameReleaseDateLabel: UILabel!
    @IBOutlet private var gameRateLabel: UILabel!
    @IBOutlet private var gameDetailLabel: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    
    private var gameID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configureData(id: Int, gameDetail: GameDetail){
        
        gameID = id
        
        if(isGameFavorite(id: gameID)){
            favoriteButton.tintColor = UIColor.systemOrange
        }else{
            favoriteButton.tintColor = .white
        }
        
        if let image = gameDetail.image {
            if let imageUrl = URL(string: image) {
                gameImageView.kf.setImage(with: imageUrl)
            }
        }
        
        gameNameLabel.text = gameDetail.name
        gameRateLabel.text = "Metacritic Rate: \(gameDetail.metacritic ?? 0)"
        
        if let date = gameDetail.released {
            gameReleaseDateLabel.text = "Release Date: \(date.dateToTRFormat())"
        }
        
        if let detail = gameDetail.description {
            gameDetailLabel.text = detail.stripHTMLTags()
        }
        
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        if isGameFavorite(id: gameID) {
            removeFromFavorite()
            favoriteButton.tintColor = .white
        }else{
            addToFavorite()
            favoriteButton.tintColor = UIColor.systemOrange
        }
        
    }
    
    func isGameFavorite(id: Int) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "game_id == %@", "\(id)")
        
        do{
            let objects = try context.fetch(fetchRequest)
            if objects.count == 0 {
                return false
            }
            return true
        }catch {
            print(error.localizedDescription)
        }
        return false
        
    }
    
    func addToFavorite(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newFav = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
        newFav.setValue(gameID, forKey: "game_id")
        
        do{
            try context.save()
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    func removeFromFavorite(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "game_id == %@", "\(gameID)")
        
        do{
            let objects = try context.fetch(fetchRequest)
            for object in objects as! [NSManagedObject]{
                context.delete(object)
            }
            try context.save()
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
}
