//
//  NoteDataController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 15/01/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import Foundation
import CoreData

class NoteDataController {
  private let context: NSManagedObjectContext
  private var note: Note?
  
  init(_ context: NSManagedObjectContext) {
    self.context = context
  }
  
  func addNote(movieId: Int,
               username: String,
               comment: String) {
    if self.note == nil {
      self.note = Note(context: context)
      self.note?.id = Float(movieId)
      self.note?.username = username
    }
    self.note?.comment = comment
    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func removeNote() {
    if let note = self.note {
      context.delete(note)
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func fetchNote(movieId: Int,
                 username: String) -> Note? {
    let fetchRequest: NSFetchRequest<Note> = NSFetchRequest(entityName: "Note")
    let idPredicate = NSPredicate(format: "id = %d", movieId)
    let usernamePredicate = NSPredicate(format: "username = %@", username)
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, usernamePredicate])
    fetchRequest.predicate = compoundPredicate
    var notes = [Note]()
    if let results = try? context.fetch(fetchRequest) {
      notes = results
    }
    self.note = notes.first
    return self.note
  }
}
