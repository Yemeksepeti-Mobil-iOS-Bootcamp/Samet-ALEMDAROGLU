//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by ALEMDAR on 21.07.2021.
//

import UIKit
import CoreData

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var movieImageView: UIImageView!
    @IBOutlet private var movieNameLabel: UILabel!
    @IBOutlet private var movieFavoriteImageView: UIImageView!
    
    static let cellID = "MovieCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configureCell(name: String?, imagePath: String?, isFavorite: Bool){
        
        movieNameLabel.text = name
        
        if let path = imagePath {
            if let imageData = createImg(width: 400, imagePath: path) {
                movieImageView.image = UIImage(data: imageData)
            }
        }
        
        if isFavorite {
            movieFavoriteImageView.image = UIImage(systemName: "star.fill")
        }else {
            movieFavoriteImageView.image = nil
        }
        
    }
    
    func isFavorite(movieID: Int) -> Bool {
        
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

}
