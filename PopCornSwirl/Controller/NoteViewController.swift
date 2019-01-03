//
//  NoteViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/01/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
  
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  
  var movie: Movie!
  var image: UIImage?
  var note: Note?
  
  private let defaultColor = UIColor(red: 101/255, green: 214/255, blue: 118/255, alpha: 1)
  private let defaultText = "Write a note here."
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNote()
    self.textView.text = self.note?.comment ?? self.defaultText
  }
  
  func setupViews() {
    self.poster.image = self.image
    self.titleLabel.text = self.movie.title
    self.saveButton.layer.cornerRadius = 5
    self.saveButton.clipsToBounds = true
  }
  
  func setNote() {
    if let navigationController = navigationController,
      let tabBarController = navigationController.tabBarController as? TabBarController,
      let persistentStore = tabBarController.persistentContainer {
      
      let context = persistentStore.viewContext
      self.note = fetchNote(context: context)
    }
  }
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    self.textView.resignFirstResponder()
    guard self.textView.text != self.defaultText &&
      self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != ""
      else { return }
    saveButton.isUserInteractionEnabled = false
    self.changeBackGroundColor(self.saveButton, color: .lightGray, duration: 0.2)
    self.saveButton.setTitle("WAITING...", for: .normal)
    if let navigationController = navigationController,
      let tabBarController = navigationController.tabBarController as? TabBarController,
      let persistentStore = tabBarController.persistentContainer {
      
      let managedObjectContext = persistentStore.viewContext
      if self.note == nil {
        self.note = Note(context: managedObjectContext)
        self.note?.id = Float(self.movie.id)
      }
      self.note?.comment = self.textView.text
      if managedObjectContext.hasChanges {
        do {
          try managedObjectContext.save()
        } catch {
          print(error.localizedDescription)
        }
        // Do after save here.
        self.changeBackGroundColor(self.saveButton, color: self.defaultColor)
        self.saveButton.setTitle("Save", for: .normal)
        saveButton.isUserInteractionEnabled = true
      }
    }
  }
  
  func fetchNote(context: NSManagedObjectContext) -> Note? {
    let fetchRequest: NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
    let idPredicate = NSPredicate(format: "id = %d", self.movie.id)
    fetchRequest.predicate = idPredicate
    var notes = [Note]()
    if let results = try? context.fetch(fetchRequest) {
      notes = results
    }
    return notes.first
  }
  
  func changeBackGroundColor(_ button: UIButton, color: UIColor, duration: TimeInterval = 0.5) {
    UIView.animate(withDuration: duration, animations: {
      button.backgroundColor = color
    })
  }
}
