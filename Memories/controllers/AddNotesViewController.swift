//
//  AddNotesViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 27.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddNotesViewController: UIViewController {
  
  var refNotes: DatabaseReference!
  let userId = (UserDefaults.standard.dictionary(forKey: "userData"))?["userId"] as! String

  @IBOutlet weak var noteTitle: SkyFloatingLabelTextField!
  @IBOutlet weak var noteTextView: UITextView!
  override func viewDidLoad() {
        super.viewDidLoad()
      
      refNotes = Database.database().reference().child("Users").child("\(userId)").child("notes")

        // Do any additional setup after loading the view.
    }
  
  
  @IBAction func saveNotesAction(_ sender: UIBarButtonItem) {
    addNotesInFirebase()
    navigationController?.popViewController(animated: true)
  }
  func addNotesInFirebase(){
    let key = refNotes.childByAutoId().key
    
    let notes = ["id": key,
                 "title": noteTitle.text! as String,
                 "note": noteTextView.text! as String]
    
    refNotes.child(key).setValue(notes)
  }

}
