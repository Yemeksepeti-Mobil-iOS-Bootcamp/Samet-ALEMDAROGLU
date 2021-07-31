//
//  FavoriteListViewController.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 16.07.2021.
//

import UIKit
import CoreData

class FavoriteListViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    
    private var favorites = [GameDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites.removeAll()
        getFavorites()
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GameCollectionViewCell.cellID)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 0, height: 0)
        }
    }
    
    private func getFavorites(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects as! [NSManagedObject] {
                if let gameID = object.value(forKey: "game_id") as? Int {
                    API().getGameDetail(id: gameID) { (GameDetail) in
                        DispatchQueue.main.async {
                            self.favorites.append(GameDetail)
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }catch {
            print(error.localizedDescription)
        }
    
    }
    
    private func setEmptyCollectionView(){
        let CVFrame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        
        let emptyView = UIView(frame: CVFrame)
        let emptyMessage = UILabel(frame: CVFrame)
        
        emptyView.addSubview(emptyMessage)
       
        emptyMessage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        emptyMessage.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true

        emptyMessage.text = "Herhangi bir favori oyun bulunmamaktadır"
        emptyMessage.textColor = .black
        emptyMessage.numberOfLines = 0
        emptyMessage.textAlignment = .center
        
        collectionView.backgroundView = emptyView
    }

}

extension FavoriteListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if favorites.isEmpty {
            setEmptyCollectionView()
        }else{
            collectionView.backgroundView = nil
        }
        
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.cellID, for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let favorite = favorites[indexPath.row]
        
        cell.configureCell(imageUrl: favorite.image, name: favorite.name, releasedDate: favorite.released, rate: "\(favorite.rating ?? 0)")
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let VC = storyBoard.instantiateViewController(withIdentifier: "GameDetailViewController") as? GameDetailViewController else {
            return
        }
        
        let favorite = favorites[indexPath.row]
        
        guard let gameID = favorite.id else{
            return
        }
        
        API().getGameDetail(id: gameID) { (GameDetail) in
            
            DispatchQueue.main.async {

                VC.configureData(id: gameID, gameDetail: GameDetail)
            }
            
            self.navigationController?.pushViewController(VC, animated: true)
        
        }
        
    }
    

}
