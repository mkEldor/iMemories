//
//  NotesViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 24.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var refNotes: DatabaseReference!

  var noteList = [NotesModel]()
  let userId = (UserDefaults.standard.dictionary(forKey: "userData"))?["userId"] as! String

  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationItem.title = "Notes"
    
    refNotes = Database.database().reference().child("Users").child("\(userId)").child("notes")
    
    refNotes.observe(DataEventType.value) { (snapshot) in
      if snapshot.childrenCount>0{
        self.noteList.removeAll()
        
        for notes in snapshot.children.allObjects as! [DataSnapshot]{
          let noteObject = notes.value as? [String : AnyObject]
          let noteTitle = noteObject?["title"]
          let note = noteObject?["note"]
          let noteId = noteObject?["id"]
          
          let notes = NotesModel(id: noteId as! String?, title: noteTitle as! String?, note: note as! String?)
          
          self.noteList.append(notes)
        }
        self.tableView.reloadData()
      }
    }
    
  }
}



extension NotesViewController{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return noteList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NotesCell
    let notes: NotesModel = noteList[indexPath.row]

    cell?.noteText.text = notes.note
    cell?.noteTitleText.text  = notes.title
    
    
    
    return cell!
  }
  
}

