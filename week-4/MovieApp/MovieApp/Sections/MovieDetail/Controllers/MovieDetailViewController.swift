//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by ALEMDAR on 22.07.2021.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {

    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var movieNameLabel: UILabel!
    @IBOutlet private var movieDescriptionLabel: UILabel!
    @IBOutlet private var movieVoteCountLabel: UILabel!
    @IBOutlet private var movieReleaseDateLabel: UILabel!
    
    private var movieID: Int = 0
    
    static let storyboardID = "MovieDetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Movie Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
    }
    
    func configureData(id: Int, imagePath: String?, name: String?, description: String?, voteCount: Int?, releaseDate: String?){
        
        movieID = id
        
        if let path = imagePath {
            if let imageData = createImg(width: 400, imagePath: path) {
                movieImageView.image = UIImage(data: imageData)
            }
        }
        
        movieNameLabel.text = name
        movieDescriptionLabel.text = description
        movieVoteCountLabel.text = "Vote: \(voteCount ?? 0)"
        if let date = releaseDate {
            movieReleaseDateLabel.text = toTRDateFormat(date: date)
        }
        
        if isFavorite() {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        }else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
        
    }
    
    @objc func favoriteButtonTapped() {
        if isFavorite() {
            removeFromFavorite()
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }else {
            addToFavorite()
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        }
    }
    
    private func createImg(width: Int ,imagePath: String) -> Data? {
        
        let imageUrl = "https://image.tmdb.org/t/p/w\(width)/\(imagePath)"
        
        if let url = URL(string: imageUrl) {
            do{
                let imageData = try Data(contentsOf: url)
                return imageData
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func toTRDateFormat(date: String) -> String {
        let getFormat = DateFormatter()
        let printFormat = DateFormatter()
        
        getFormat.dateFormat = "YYYY-mm-dd"
        printFormat.dateFormat = "dd.mm.YYYY"
        
        if let date = getFormat.date(from: date) {
            return printFormat.string(from: date)
        }
        return "-"
    }
    
    
    private func isFavorite() -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "movie_id == %@", "\(movieID)")
        
        do {
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
    
    private func addToFavorite(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newFav = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
        newFav.setValue(movieID, forKey: "movie_id")
        
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    private func removeFromFavorite(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "movie_id == %@", "\(movieID)")
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects as! [NSManagedObject] {
                context.delete(object)
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
}
