//
//  ViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MemoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
  
  let userId = (UserDefaults.standard.dictionary(forKey: "userData"))?["userId"] as! String
  var refMemories: DatabaseReference!
  var getData = ""
  var getDate = ""
  var memories: MemoriesModel?
  var memoriesList = [MemoriesModel]()
  var getMemoryList: [String] = []
  var imageReturn: [Int] = []
  var videoReturn: [Int] = []
  var userName = ""
  
  var edit: Bool? = false
  
  @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
    if sender.image == #imageLiteral(resourceName: "delete-2") {
      edit = true
      sender.image = #imageLiteral(resourceName: "check-mark")
    }else{
      edit = false
      sender.image = #imageLiteral(resourceName: "delete-2") 
    }
  }
  
  @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var collectionView: UICollectionView!
  var screenSize: CGRect!
  var screenWidth: CGFloat!
  var screenHeight: CGFloat!
  var getImagesArray: [String?] = []
  var getVideoArray: [String?] = []
  
  override func viewDidLoad() {
    loadingIndicatorView.stopAnimating()
    super.viewDidLoad()
    refMemories = Database.database().reference().child("Users").child("\(userId)").child("memories")
    getName()
    cellAnimation()
    getMemories()
    getImagesArray.removeAll()
    getVideoArray.removeAll()
  }
  
  func getMemories(){
    getMemoryList.removeAll()
    
    refMemories.observe(DataEventType.value) { (snapshot) in
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
          
          if memoryImages != nil && memoryVideos != nil{
            self.imageReturn.append(1)
            self.videoReturn.append(1)
            self.memories = MemoriesModel(id: memoryId as! String?, memory: memory as! String?, date: (memoryDate as! String?)! + " " + (memoryTime as! String? )!, imageURL: memoryImages as! [String?], videoURL: memoryVideos as! [String?])
          }else if memoryImages != nil && memoryVideos == nil{
            self.imageReturn.append(1)
            self.videoReturn.append(0)
            self.memories = MemoriesModel(id: memoryId as! String?, memory: memory as! String?, date: (memoryDate as! String?)! + " " + (memoryTime as! String? )!, imageURL: memoryImages as! [String?], videoURL: [])
          }else if memoryImages == nil && memoryVideos != nil{
            self.imageReturn.append(0)
            self.videoReturn.append(1)
            self.memories = MemoriesModel(id: memoryId as! String?, memory: memory as! String?, date: (memoryDate as! String?)! + " " + (memoryTime as! String? )!, imageURL: [], videoURL: memoryVideos as! [String?])
          }else{
            self.imageReturn.append(0)
            self.videoReturn.append(0)
            self.memories = MemoriesModel(id: memoryId as! String?, memory: memory as! String?, date: (memoryDate as! String?)! + " " + (memoryTime as! String? )!, imageURL: [], videoURL: [])
          }
          
          
          self.memoriesList.append(self.memories!)
        }
        self.collectionView.reloadData()
      }
    }
  }
  
  func getName(){
    Database.database().reference().child("Users").child("\(userId)").observeSingleEvent(of: .value) { (snapshot) in
          let dict = snapshot.value as? Dictionary<String,Any>
      print(dict!["username"] as! String)
      
      
      self.userName = dict!["username"] as! String
      
      NotificationCenter.default.post(name: Notification.Name.init("Username"), object: self.userName)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    collectionView.reloadData()
    getImagesArray.removeAll()
    getVideoArray.removeAll()
    print("loading")
  }
  
  @IBAction func addMemory(_ sender: Any) {
    performSegue(withIdentifier: "addMemory", sender: self)
  }
  
}

extension MemoriesViewController{
  
  func cellAnimation(){
    screenSize = UIScreen.main.bounds
    screenWidth = screenSize.width
    screenHeight = screenSize.height

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let bottomConstraint = CGFloat( memoriesList.count % 2) * screenWidth/3 + 1
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomConstraint, right: 0)
    layout.itemSize = CGSize(width: screenWidth/2 , height: screenWidth/3)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    collectionView!.collectionViewLayout = layout

  }
}


extension MemoriesViewController{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memoriesList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoriesCell", for: indexPath) as! MemoriesCell
    let memories: MemoriesModel = memoriesList[indexPath.item]
    
    cell.textLabel.text = memories.memory
    cell.dateLabel.text = memories.date
    if imageReturn[indexPath.item] == 1 && videoReturn[indexPath.item] == 1{
      cell.imageIcon.image = #imageLiteral(resourceName: "gallery")
      cell.videoIcon.image = #imageLiteral(resourceName: "video")
      print("ONE")
    }
    else if imageReturn[indexPath.item] == 1 && videoReturn[indexPath.item] == 0{
      cell.imageIcon.image = #imageLiteral(resourceName: "gallery")
      print("TWO")
    }
    else if imageReturn[indexPath.item] == 0 && videoReturn[indexPath.item] == 1{
      cell.imageIcon.image = #imageLiteral(resourceName: "video")
      print("THREE")
    }
    else if imageReturn[indexPath.item] == 0 && videoReturn[indexPath.item] == 0{
      print("FOUR")
    }
    
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let memories: MemoriesModel = memoriesList[indexPath.item]
    if edit == false{
      self.loadingIndicatorView.isHidden = false
      self.loadingIndicatorView.startAnimating()
      getImagesArray.removeAll()
      getData = memories.memory!
      getDate = memories.date!
      getImagesArray = memories.imageURL
      getVideoArray = memories.videoURL
      performSegue(withIdentifier: "showMemory", sender: self)
      self.loadingIndicatorView.stopAnimating()
    } else{
      let alertView = UIAlertController(title: nil, message: "Удалить этот запись?", preferredStyle: UIAlertControllerStyle.alert)
      
      alertView.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
      alertView.addAction(UIAlertAction(title: "Да", style: .default, handler: { (_) in
        self.deletePost(memories.id!)
      }))
      
      self.present(alertView, animated: true, completion: nil)
    }
  }
  
  func deletePost(_ id: String){
    refMemories.child(id).setValue(nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMemory" {
      let toNextVC = segue.destination as? ShowMemoryViewController
      toNextVC?.titlle = "\(getDate)"
      toNextVC?.imageUrlList = getImagesArray
      toNextVC?.videoUrlList  = getVideoArray
      getVideoArray.removeAll()
      getImagesArray.removeAll()
      toNextVC?.showText = "\(getData) \n \n \n       \(getDate)    \(userName)"
    }else if segue.identifier == "addMemory" {
      let toNextVC = segue.destination as? NewMemoryViewController
      toNextVC?.getIndexPath = memoriesList.count
      toNextVC?.username = "\(userName)"
      
    }
    
  }
  
}


