//
//  GameListViewController.swift
//  VideoGamesApp
//
//  Created by ALEMDAR on 16.07.2021.
//

import UIKit
import Kingfisher

class GameListViewController: UIViewController {
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var games = [Game]()
    private var filteredGames = [Game]()
    private var sliderImages = [String]()
    private var sliderCounter = 0
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty && (searchController.searchBar.text?.count ?? 0) > 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        configureNavigationBar()
        configureSliderCollectionView()
        configureCollectionView()
        getGamesData()
        
    }
    
    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search a game..."
        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func configureNavigationBar(){
        navigationItem.searchController = searchController
    }
    
    private func configureSliderCollectionView() {
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.changeSlider), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeSlider() {
        if sliderCounter == sliderImages.count {
            sliderCounter = 0
            sliderCollectionView.scrollToItem(at: IndexPath(item: sliderCounter, section: 0), at: .centeredHorizontally, animated: true)
            pageControl.currentPage = sliderCounter
            sliderCounter = 1
        }else{
            sliderCollectionView.scrollToItem(at: IndexPath(item: sliderCounter, section: 0), at: .centeredHorizontally, animated: true)
            pageControl.currentPage = sliderCounter
            sliderCounter += 1
        }
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GameCollectionViewCell.cellID)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 0.0, height: 0.0)
        }
        
    }
    
    private func getGamesData() {
        API().getGames { (GameResponse) in
            DispatchQueue.main.async {
                if let games = GameResponse.games {
                    self.games = games
                    self.collectionView.reloadData()
                    
                    for (i,game) in games.enumerated() {
                        if i == 5 { break }
                        self.sliderImages.append(game.image ?? "")
                        self.sliderCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension GameListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            
            if isFiltering {
                return filteredGames.count
            }
            
            return games.count
        }
        
        return sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.cellID, for: indexPath) as? GameCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            
            let game: Game
            
            if isFiltering {
                game = filteredGames[indexPath.row]
            }else{
                game = games[indexPath.row]
            }
            cell.configureCell(imageUrl: game.image,
                               name: game.name,
                               releasedDate: game.released,
                               rate: "\(game.rating ?? 0)")

            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath)
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            if let imageUrl = URL(string: sliderImages[indexPath.row]) {
                imageView.kf.setImage(with: imageUrl)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            return CGSize(width: self.collectionView.frame.width, height: 130)
        }
        
        return CGSize(width: self.sliderCollectionView.frame.size.width, height: self.sliderCollectionView.frame.size.height)
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
        
        let game = games[indexPath.row]
        
        guard let gameID = game.id else{
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

extension GameListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if isFiltering {
            if let text = searchController.searchBar.text {
                
                filteredGames = games.filter({ (game) -> Bool in
                    return game.name?.lowercased().contains(text.lowercased()) ?? false
                })
                
            }

            if filteredGames.count == 0 {
                
                let CVFrame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                let emptyView = UIView(frame: CVFrame)
                let emptyMessage = UILabel(frame: CVFrame)
                
                emptyView.addSubview(emptyMessage)
               
                emptyMessage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
                emptyMessage.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true

                emptyMessage.text = "Üzgünüz, aradığınız oyun bulunamadı!"
                emptyMessage.textColor = .black
                emptyMessage.numberOfLines = 0
                emptyMessage.textAlignment = .center
                
                collectionView.backgroundView = emptyView
            }
        }
        collectionView.reloadData()
    }
    
}
