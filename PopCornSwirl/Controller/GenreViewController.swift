//
//  GenreViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 05/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var genreList = GenreList(genres: [Genre]())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupDelegation()
    GenresController().requestGenreList {
      (success: Bool, decodable: Decodable) in
      if success {
        DispatchQueue.main.async {
          let genres = decodable as! GenreList
          self.genreList = genres
          self.tableView.reloadData()
        }
      } else {
        // TODO: Handle Error create UIAlert
        let error = decodable as! Error
        print(error.statusMessage)
      }
    }
  }
  
  func setupDelegation() {
    self.tableView.dataSource = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier,
      let cell = sender as? UITableViewCell,
      let indexpath = tableView.indexPath(for: cell),
      identifier == "MovieListSegue" {
      // Send all genre and selected genre index to Movie view Controller
      let row = indexpath.row
      let viewController = segue.destination as! MovieViewController
      viewController.currentGenreIndex = row
      viewController.genreList = self.genreList
    }
  }
}

// MARK: --> UITableView Datasource
extension GenreViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.genreList.genres.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
    let genre = genreList.genres[indexPath.row]
    cell.textLabel?.adjustsFontSizeToFitWidth = true
    cell.textLabel?.text = genre.name
    return cell
  }
}
