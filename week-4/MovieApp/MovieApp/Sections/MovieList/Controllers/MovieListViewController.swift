//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by ALEMDAR on 21.07.2021.
//

import UIKit

class MovieListViewController: UIViewController{

    @IBOutlet private var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let gridButtonView = UIView()
    private let listButtonView = UIView()
    
    private var movies = [Movie]()
    private var filteredMovies = [Movie]()
    private var currentPage: Int = 1
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search a movie..."
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func configureNavigationBar(){
        
        navigationItem.searchController = searchController
        
        let gridButton = UIButton()
        
        gridButtonView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        gridButtonView.backgroundColor = UIColor.rgba(red: 51, green: 51, blue: 51, alpha: 1)
        gridButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        gridButton.setImage(UIImage(named: "grid_view")?.withTintColor(.white), for: .normal)
        gridButton.addTarget(self, action: #selector(setGridView), for: .touchUpInside)
        
        gridButtonView.addSubview(gridButton)
        
        let tableButton = UIButton()
        
        listButtonView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        listButtonView.backgroundColor = UIColor.rgba(red: 51, green: 51, blue: 51, alpha: 1)
        tableButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        tableButton.setImage(UIImage(named: "table_view")?.withTintColor(.white), for: .normal)
        tableButton.addTarget(self, action: #selector(setListView), for: .touchUpInside)
        
        listButtonView.addSubview(tableButton)
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: gridButtonView)
  
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.cellID)
        
        // Layout
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 0, height: 0)
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 150)
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 0
        }
    }
    
    private func getMovies(){
        API().getMoviesData(page: currentPage) { (MovieResponse) in
            DispatchQueue.main.async {
                if let movies = MovieResponse.movies {
                    self.movies = movies
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func setGridView(){
        collectionView.performBatchUpdates({
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: self.collectionView.frame.width / 2 - 5, height: 300)
                layout.minimumLineSpacing = 10
            }
        }, completion: nil)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: listButtonView)
    }
    
    @objc private func setListView(){
        collectionView.performBatchUpdates({
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 150)
                layout.minimumLineSpacing = 20
            }
        }, completion: nil)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: gridButtonView)
    }

    private func loadMoreItems(){
        currentPage += 1
        API().getMoviesData(page: currentPage) { (MovieResponse) in
            DispatchQueue.main.async {
                if let movies = MovieResponse.movies {
                    self.movies.append(contentsOf: movies)
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredMovies.count
        }
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.cellID, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie: Movie
        let isFavorite: Bool
        
        if isFiltering {
            movie = filteredMovies[indexPath.row]
        }else {
            movie = movies[indexPath.row]
        }
      
        guard let movieID = movie.id else {
            return UICollectionViewCell()
        }
        
        isFavorite = cell.isFavorite(movieID: movieID)
          
        cell.configureCell(name: movie.name, imagePath: movie.poster, isFavorite: isFavorite)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let VC = storyBoard.instantiateViewController(withIdentifier: MovieDetailViewController.storyboardID) as? MovieDetailViewController else {
            return
        }
            
        let movie: Movie
        
        if isFiltering {
            movie = filteredMovies[indexPath.row]
        }else {
            movie = movies[indexPath.row]
        }
        
        guard let movieID = movie.id else {
            return
        }
        
        self.navigationController?.pushViewController(VC, animated: true)
        
        API().getMovieDetail(id: movieID) { (MovieDetail) in
            DispatchQueue.main.async {
                VC.configureData(id: movieID, imagePath: MovieDetail.poster, name: MovieDetail.name, description: MovieDetail.description, voteCount: MovieDetail.voteCount, releaseDate: MovieDetail.releaseDate)
            }
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            loadMoreItems()
        }
    }
    
}

extension MovieListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if isFiltering {
            if let text = searchController.searchBar.text {
                filteredMovies = movies.filter { (Movie) -> Bool in
                    return Movie.name?.contains(text) ?? false
                }
            }
        }
        collectionView.reloadData()
       
    }
    
}
