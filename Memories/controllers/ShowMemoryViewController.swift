//
//  ShowMemoryViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 05.08.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import AVFoundation
import AVKit

class ShowMemoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.tag == 0{
      return imageList.count
    }else{
      return videoScreenList.count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.tag == 0{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ShowImageCollectionViewCell
      
      cell.showImage.image = imageList[indexPath.item]
      
      return cell
    }else{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "video", for: indexPath) as! ShowVideoCollectionViewCell
      
      cell.showVideoScreenImage.image = videoScreenList[indexPath.item]
      
      return cell
    }
    
  }
  
  
  @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var videoCollectionView: UICollectionView!
  var showText = ""
  var imageUrlList: [String?] = []
  var videoUrlList: [String?] = []
  var titlle = ""
  var imageList: [UIImage] = []
  var videoScreenList: [UIImage] = []
  var getImage: UIImage = #imageLiteral(resourceName: "video")
  var getIndex = 0
  
  
  var y_VideoCollectionView: CGFloat?
  var collectionOrientation: Bool? = false
  
  
  let avPlayerViewController = AVPlayerViewController()
  var avPlayer: AVPlayer?
  
  @IBOutlet weak var showMemoryText: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
    y_VideoCollectionView = videoCollectionView.frame.origin.y
    videoCollectionView.frame.origin.y = imageCollectionView.frame.origin.y
    imageList.removeAll()
    self.title = titlle
    showMemoryText.text = showText
    print("PHOTOS:")
    
    downloadPhoto()
    downloadVideoScreen()
    
    if videoScreenList != []{
      
    }
    
  }
  
  
  func downloadPhoto(){
    let storage = Storage.storage()
    for url in imageUrlList{
      self.loadingIndicatorView.isHidden = false
      self.loadingIndicatorView.startAnimating()
      let reference: StorageReference = storage.reference(forURL: url!)
      print(url!)
      reference.downloadURL { (url, error) in
        self.loadingIndicatorView.isHidden = false
        self.loadingIndicatorView.startAnimating()

        guard let imageURL = url, error == nil else {
          self.loadingIndicatorView.isHidden = false
          self.loadingIndicatorView.startAnimating()

          return
        }
        guard let data = NSData(contentsOf: imageURL) else {
          self.loadingIndicatorView.isHidden = false
          self.loadingIndicatorView.startAnimating()
          return
        }
        let image = UIImage(data: data as Data)
        self.imageList.append(image!)
        self.imageCollectionView.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
          self.videoCollectionView.frame.origin.y = self.y_VideoCollectionView!
        })
        print(self.imageList.count)
        print(self.imageList)
        self.loadingIndicatorView.stopAnimating()
        self.collectionOrientation = true
        if self.collectionOrientation!{
          self.videoCollectionView.frame.origin.y = self.y_VideoCollectionView!
        }
        
        
      }
      self.loadingIndicatorView.stopAnimating()
      
    }
    

    
    self.imageCollectionView.reloadData()
  }
  
  func downloadVideoScreen(){
    for url in videoUrlList{
      if let thumbnailImage = self.thumbnailImageFOrVideoUrl(NSURL(string: url!)!){
        self.videoScreenList.append(thumbnailImage)
        print(self.videoScreenList.count)
        self.videoCollectionView.reloadData()
        
      }
    }
  }
  
  
  private func thumbnailImageFOrVideoUrl(_ videoUrl: NSURL) -> UIImage?{
    let asset = AVAsset(url: videoUrl as URL)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    
    do {
      
      let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
      return UIImage(cgImage: thumbnailCGImage)
      
    } catch let err {
      print(err)
    }
    
    return nil
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    getIndex = indexPath.item
    if collectionView.tag == 0{
      performSegue(withIdentifier: "showImage", sender: self)
    }else{
      
      let movieUrl: NSURL? = NSURL(string: videoUrlList[getIndex]!)
      
      if let url = movieUrl{
        self.avPlayer = AVPlayer(url: url as URL)
        self.avPlayerViewController.player = self.avPlayer
      }
      
      try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])

        self.present(avPlayerViewController, animated: true) {
          self.avPlayer?.isMuted = false
  
        self.avPlayerViewController.player?.play()
      }
      
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showImage" {
      let toNextVC = segue.destination as? ShowImageViewController
        toNextVC?.image = imageList
        toNextVC?.index = getIndex
      
    }
  }
  
  
  
}
