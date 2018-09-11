//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class MyAccountViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate{
  
  @IBOutlet weak var mainTableView: UITableView!

  var barImages2 = [#imageLiteral(resourceName: "collectionIcon-1"), #imageLiteral(resourceName: "listView"), #imageLiteral(resourceName: "writing-2")]
  var barImages1 = [#imageLiteral(resourceName: "collectionIcon"), #imageLiteral(resourceName: "listView"), #imageLiteral(resourceName: "writing-2")]
  var barImages = [#imageLiteral(resourceName: "collectionIcon-1"), #imageLiteral(resourceName: "listView-1"), #imageLiteral(resourceName: "writing")]
  var formatt = 0
  var ref: DatabaseReference!
  
  var imageReturn: [Int] = []
  var videoReturn: [Int] = []
  
  var noteList = [NotesModel]()
  var memoriesList = [MemoriesModel]()
  let userId = (UserDefaults.standard.dictionary(forKey: "userData"))?["userId"] as! String
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getNotes()
    getMemories()
    mainTableView.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getNotes()
    getMemories()
    print("MEMORIESSSd: \(memoriesList.count)")
    print("NOTESSSd: \(noteList.count)")
    mainTableView.reloadData()
  }
  
 
  func getNotes(){
    ref = Database.database().reference().child("Users").child("\(userId)").child("notes")
    
    ref.observe(DataEventType.value) { (snapshot) in
      if snapshot.childrenCount>0{
        self.noteList.removeAll()
        
        for notes in snapshot.children.allObjects as! [DataSnapshot]{
          let noteObject = notes.value as? [String : AnyObject]
          let noteTitle = noteObject?["title"]
          let note = noteObject?["note"]
          let noteId = noteObject?["id"]
          
          let notes = NotesModel(id: noteId as! String?, title: noteTitle as! String?, note: note as! String?)
          
          self.noteList.append(notes)
          self.mainTableView.reloadData()
          
        }
        
        print("NOTES")
        
        print(self.noteList.count)
        self.mainTableView.reloadData()
      }
    }
  }
  
  func getMemories(){
    ref = Database.database().reference().child("Users").child("\(userId)").child("memories")

    ref.observe(DataEventType.value) { (snapshot) in
      if snapshot.childrenCount > 0 {
        self.memoriesList.removeAll()
        
        for memories in snapshot.children.allObjects as! [DataSnapshot]{
          let memoryObject = memories.value as? [String : AnyObject]
          let memory = memoryObject?["memory"]
          let memoryId = memoryObject?["id"]
          let memoryDate = memoryObject?["date"]
          let memoryTime = memoryObject?["time"]
          let memoryImages = memoryObject!["ImageUrls"]
          let memoryVideos = memoryObject!["VideoUrls"]
          
          if memoryImages != nil{
            self.imageReturn.append(1)
          }else{
            self.imageReturn.append(0)
          }
          
          if memoryVideos != nil{
            self.videoReturn.append(1)
          }else{
            self.videoReturn.append(0)
            
          }
          
          let memories = MemoriesModel(id: memoryId as! String?, memory: memory as! String?, date: (memoryDate as! String?)! + " " + (memoryTime as! String? )!, imageURL: [], videoURL: [])
          
          
          self.memoriesList.append(memories)
          self.mainTableView.reloadData()
        }
        print("MEMORIES")
        self.mainTableView.reloadData()
      }
    }
  }
  
  @IBAction func logOutAction(_ sender: UIBarButtonItem) {
    do{
      try Auth.auth().signOut()
    }catch{
      
    }

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC") as? LoginPageViewController
    
    self.present(mainVC!, animated: true, completion: nil)
    
  }
}


extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource{
 
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView.tag == 0 {
      return 3
    }else{
      return noteList.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView.tag == 0{
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as? AccountInformCell
        
        
        cell?.memoriesCountLabel.text = "Воспоминания: \(memoriesList.count)"
        cell?.notesCountLabel.text = "Записки: \(noteList.count)"
        
        return cell!
        
      }
      else if indexPath.row == 1{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? ChangeInformCell
        
        return cell!
      }
      else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? InformViewTableViewCell
        cell?.reload = true
        return cell!
      }
    }
    else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as? NotesFromAccountCVCell
      let notes: NotesModel = noteList[indexPath.row]
      
      cell?.noteText.text = notes.note
      cell?.titleLabel.text  = notes.title
      return cell!
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView.tag == 0{
      
      if indexPath.row == 2 {
        return UIScreen.main.bounds.height - 232
        
      }else if indexPath.row == 1{
        return 40
      } else {
        return UITableViewAutomaticDimension
      }
    }else{
      return UITableViewAutomaticDimension
    }
  }
  
}




extension MyAccountViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.tag == 1{
      return 3
    }
    else{
      return memoriesList.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView.tag == 0{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoriesCell", for: indexPath) as? InformViewFormatCell
      let memories: MemoriesModel = memoriesList[indexPath.item]
      cell?.memoryText.text = memories.memory
      
      
      return cell!
    }else{
      let barCell = collectionView.dequeueReusableCell(withReuseIdentifier: "barCell", for: indexPath) as? changeBarImageCell
      
        barCell?.barImage.image = barImages1[indexPath.row]
      
      return barCell!
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView.tag == 0{
      if formatt == 0{
        return CGSize(width: collectionView.frame.width / 2, height: 125)
      } else if formatt == 1{
        return CGSize(width: collectionView.frame.width, height: 300)
      }else{
        return CGSize(width: 0, height: 0)
      }
    }
    else if collectionView.tag == 2{
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/3)
    }
    else{
      return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView.tag == 1{
      let selectedCell = collectionView.cellForItem(at: indexPath) as? changeBarImageCell
      
      selectedCell?.barImage.image = barImages[indexPath.item]
      
      formatt = indexPath.item
      
      NotificationCenter.default.post(name: Notification.Name.init("Qwerty"), object: formatt)
      
      mainTableView.reloadData()
      
      
      print("MEMORIESSS: \(memoriesList.count)")
      print("NOTESSS: \(noteList.count)")
      print("Selected")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if collectionView.tag == 1{
      let deselectedCell = collectionView.cellForItem(at: indexPath) as? changeBarImageCell
      
      deselectedCell?.barImage.image = barImages1[indexPath.item]
      
      print("Deselected")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let temp = self.memoriesList[sourceIndexPath.item]
    let sourceItem = self.memoriesList[destinationIndexPath.item]
    if collectionView.tag == 0{
      self.memoriesList[sourceIndexPath.item] = sourceItem
      self.memoriesList[destinationIndexPath.item] = temp
    }
    collectionView.reloadData()
    
  }
}






