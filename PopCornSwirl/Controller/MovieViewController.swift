//
//  MovieViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
  
  var currentGenreIndex: Int!
  var genreList: GenreList!
  
  var movies = [Movie]()
  var currentPage = 0
  var totalPages = 0
  
  var currentGenre: Genre {
    return genreList.genres[currentGenreIndex]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionViewFlowLayout.scrollDirection = .vertical
    self.loadMovies()
  }
  
  func loadMovies(page: Int = 1) {
    let genreIndex = currentGenre.id
    MoviePageController().requestMovie(page: page, genreIndex: genreIndex) {
      (success, decodable) in
      if success {
        let moviePage = decodable as! MoviePage
        let movies = moviePage.results ?? []
        self.movies.append(contentsOf: movies)
        self.currentPage = moviePage.page ?? 0
        self.totalPages = moviePage.totalPages ?? 0
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      } else {
        let error = decodable as! Error
        // TODO: UIAlertControler
        print(error.statusMessage)
      }
    }
  }
}

// MARK: --> UICollectionViewDelegateFlowLayout
extension MovieViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let w = collectionView.frame.size.width
    return CGSize(width: (w - 20)/2, height: 290)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
    return 30
  }
}

// MARK: --> UICollectionViewDataSource
extension MovieViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
      as! CollectionViewCell
    // if last item load more movies
    if indexPath.row == self.movies.count - 1 {
      self.loadMoreMovies()
    }
    let title = self.movies[indexPath.row].title
    cell.populate(title: title)
    self.setImage(indexPath: indexPath, cell: cell)
    return cell
  }
  
  /// Check if more movies and load then
  func loadMoreMovies() {
    guard self.totalPages > 0 else { return }
    if self.currentPage < self.totalPages {
      let nextPage = self.currentPage + 1
      self.loadMovies(page: nextPage)
    }
  }
  
  func setImage(indexPath: IndexPath, cell: CollectionViewCell) {
    self.resetPoster(cell: cell)
    let index = indexPath.row
    guard let id = self.movies[index].id else { return }
    
    if let image = MovieImage.poster[id] {
      // Image already in memory
      cell.setImage(image: image)
    } else if let path = self.movies[index].posterPath {
      // Call for network to download image into memory and set it
      ImageController().imageFrom(relativePath: path) {
        (image) in
        DispatchQueue.main.async {
          // Put image in memory
          MovieImage.poster[id] = image
          // Set image in collectionView
          cell.setImage(image: image)
        }
      }
    }
  }
  
  func resetPoster(cell: CollectionViewCell) {
    cell.setImage(image: nil)
    cell.poster.backgroundColor = UIColor.lightGray
  }
}

// MARK: --> UICollectionViewDelegate
extension MovieViewController: UICollectionViewDelegate {
}
