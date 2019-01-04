//
//  NoteViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/01/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData

class NoteViewController: UIViewController {
  
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var bannerView: GADBannerView!
  
  var movie: Movie!
  var image: UIImage?
  var note: Note?
  
  private let defaultColor = UIColor(red: 101/255, green: 214/255, blue: 118/255, alpha: 1)
  private let defaultText = "Write a note here."
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGoogleBannerView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNote()
    self.textView.text = self.note?.comment ?? self.defaultText
  }
  
  func setupViews() {
    self.textView.delegate = self
    self.poster.image = self.image
    self.titleLabel.text = self.movie.title
    self.saveButton.layer.cornerRadius = 5
    self.saveButton.clipsToBounds = true
  }
  
  func setupGoogleBannerView() {
    // Sample Ad unit ID for banner: ca-app-pub-3940256099942544/2934735716
    bannerView.adUnitID = API.adUnitID
    bannerView.rootViewController = self
    let request = GADRequest()
    request.tag(forChildDirectedTreatment: true)
    request.contentURL = "https://www.themoviedb.org/movie/\(self.movie.id)"
    request.testDevices = [kGADSimulatorID]
    bannerView.load(request)
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
    let context = self.getManagedObjectContext()
    
    if self.textView.text == self.defaultText ||
      self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      self.removeNote(context: context)
      self.textView.text = self.defaultText
      return
    }
    self.changeButtonAppearance(isWaiting: true)
    // Add note to Persitent Store
    self.addNote(context: context)
    self.changeButtonAppearance(isWaiting: false)
  }
  
  func addNote(context: NSManagedObjectContext) {
    if self.note == nil {
      self.note = Note(context: context)
      self.note?.id = Float(self.movie.id)
    }
    self.note?.comment = self.textView.text
    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func removeNote(context: NSManagedObjectContext) {
    if let note = self.note {
      self.changeButtonAppearance(isWaiting: true)
      context.delete(note)
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
      self.changeButtonAppearance(isWaiting: false)
    }
  }
  
  func getManagedObjectContext() -> NSManagedObjectContext {
    guard let navigationController = navigationController,
      let tabBarController = navigationController.tabBarController as? TabBarController,
      let persistentStore = tabBarController.persistentContainer
      else {
        fatalError("NSPersistentContainer not found")
    }
    return persistentStore.viewContext
  }
  
  func changeButtonAppearance(isWaiting: Bool) {
    var color = self.defaultColor
    var title = "Save"
    var isUserInteractionEnabled = true
    var duration = 0.5
    
    if isWaiting {
      color = .lightGray
      duration = 0.2
      isUserInteractionEnabled = false
      title = "WAITING..."
    }
    
    // Change button appearance
    self.changeBackGroundColor(self.saveButton, color: color, duration: duration)
    self.saveButton.setTitle(title, for: .normal)
    saveButton.isUserInteractionEnabled = isUserInteractionEnabled
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

extension NoteViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if self.textView.text == self.defaultText {
      self.textView.text = ""
    }
  }
}
