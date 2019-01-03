//
//  MovieViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol MovieDelegate: class {
  func requestDataFromNetwork(page:Int,
                              completion: @escaping (Bool, Decodable) -> ())
}

class MovieViewController: UIViewController {
  
  @IBOutlet weak var waitingView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
  var delegate: MovieDelegate!
  
  var movies = [Movie]()
  var currentPage = 0
  var totalPages = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionViewFlowLayout.scrollDirection = .vertical
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.loadMovies()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.waitingView.isHidden = false
    self.resetData()
    self.collectionView.reloadData()
  }
  
  func loadMovies(page: Int = 1) {
    self.delegate.requestDataFromNetwork(page: page) {
      (success, decodable) in
      if success {
        let moviePage = decodable as! Page
        let results = moviePage.results
        self.movies.append(contentsOf: results)
        self.currentPage = moviePage.number
        self.totalPages = moviePage.total
        DispatchQueue.main.async {
          self.collectionView.reloadData()
          self.waitingView.isHidden = true
        }
      } else {
        let error = decodable as! Response
        print(error.statusMessage)
        DispatchQueue.main.async {
          let alert = UIAlertController.serverAlert()
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
  
  func resetData() {
    self.movies = [Movie]()
    self.currentPage = 0
    self.totalPages = 0
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let cell = sender as? CollectionViewCell,
      segue.identifier == "MovieDetailSegue",
      let indexPath = self.collectionView.indexPath(for: cell) {
      let row = indexPath.row
      let movie = self.movies[row]
      let viewController = segue.destination as! MovieDetailViewController
      viewController.movie = movie
    }
  }
}

// MARK: --> UICollectionViewDelegateFlowLayout
extension MovieViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 185 * 0.75, height: 250 * 0.75)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
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
  
  /// Check if there are more movies and load then
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
    let id = self.movies[index].id
    
    if let image = MovieImage.poster[id] {
      // Image already in memory
      cell.setImage(image: image)
    } else if let path = self.movies[index].posterPath {
      // Call for network to download image into memory and set it
      ImageController().downloadFrom(relativePath: path) {
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
