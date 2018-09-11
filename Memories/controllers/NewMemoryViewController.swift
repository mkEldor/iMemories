
//
//  NewMemoryViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 25.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class NewMemoryViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var timeTF: UITextField!
  @IBOutlet weak var dateSeperatorView: UIView!
  @IBOutlet weak var dateTF: UITextField!
  @IBOutlet weak var timeSeperatorView: UIView!
  @IBOutlet weak var pickerView: UIView!
  @IBOutlet weak var timePicker: UIDatePicker!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var videoCollectionView: UICollectionView!
  @IBOutlet weak var imageCollectionview: UICollectionView!
  
  @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
  
  
  var refMemory: DatabaseReference!
  var indexImage = -1
  var indexVideo = -1
  var downloadUrl: String = ""
  var image_downloadUrlList: [String] = []
  var video_downloadUrlList: [String] = []
  var photo_or_video = ""
  
  
  
  var getIndexPath = 0
  var pickerType = ""
  var username = ""
  
  
  var images: [UIImage] = []
  var videoScreenImageList: [UIImage] = []

  
  var imageRef : StorageReference{
    return Storage.storage().reference().child("images").child("\(username) - \(getIndexPath)")
    
  }
  
  var videoRef :StorageReference{
    return Storage.storage().reference().child("videos").child("\(username) - \(getIndexPath)")
  }
  
  let imagePicker = UIImagePickerController()
  let userId = (UserDefaults.standard.dictionary(forKey: "userData"))?["userId"] as! String
  
  
  @IBOutlet weak var newMemoryTextView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.pickerView.frame.origin.y = UIScreen.main.bounds.height
    
    images.removeAll()
    videoScreenImageList.removeAll()
    imagePicker.delegate = self
    
    refMemory = Database.database().reference().child("Users").child("\(userId)").child("memories")
    newMemoryTextView.text = "Новое воспоминание"
    newMemoryTextView.textColor = UIColor.lightGray
    
    newMemoryTextView.becomeFirstResponder()
    
    newMemoryTextView.selectedTextRange = newMemoryTextView.textRange(from: newMemoryTextView.beginningOfDocument, to: newMemoryTextView.beginningOfDocument)
    
  }
  
  
  @IBAction func saveMemoryAction(_ sender: UIBarButtonItem) {
    
    self.view.endEditing(true)
    
    if newMemoryTextView.text == "" || dateTF.text == "" || timeTF.text == ""{
      ToastView.shared.short(self.view, txt_msg: "Заполните все поля")
    }else{
      sender.isEnabled = false
      self.dismiss(animated: true) {
        self.addMemoryInFirebase(){
        }
      }
    }
    
    
  }
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  
  @IBAction func addFilesButton(_ sender: UIBarButtonItem) {
    
    let imagePickerAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let imageFromLibAction = UIAlertAction(title: "Фотогалерея", style: .default, handler: self.photoFromLibrary)
    let videoFromLibAction = UIAlertAction(title: "Видео", style: .default, handler: self.videoFromLibrary)
    
    let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { (Void) in
      
      imagePickerAlertController.dismiss(animated: true, completion: nil)
    }
    
    imagePickerAlertController.addAction(imageFromLibAction)
    imagePickerAlertController.addAction(videoFromLibAction)
    imagePickerAlertController.addAction(cancelAction)
    
    present(imagePickerAlertController, animated: true, completion: nil)
  }
  
  
  
  func photoFromLibrary(alert: UIAlertAction!){
    photo_or_video = "photo"
    imagePicker.allowsEditing = false
    
    imagePicker.sourceType = .photoLibrary
    imagePicker.mediaTypes = [kUTTypeImage as String]
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  func videoFromLibrary(alert: UIAlertAction!){
    photo_or_video = "video"
    
    imagePicker.allowsEditing = false
    
    imagePicker.sourceType = .photoLibrary
    imagePicker.mediaTypes = [kUTTypeMovie as String]
    
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  func uploadingImage( img : UIImageView, completion: @escaping ((String) -> Void)) {
    let storeImage = self.imageRef.child("imageee-\(indexImage).jpg")
    
    if let uploadImageData = UIImagePNGRepresentation((img.image)!){
      let uploadTask = storeImage.putData(uploadImageData, metadata: nil, completion: { (metaData, error) in
        storeImage.downloadURL(completion: { (url, error) in
          if let urlText = url?.absoluteString {
            
            self.downloadUrl = urlText
            completion(self.downloadUrl)
          }
        })
      })
      uploadTask.observe(.progress) { (snapshot) in
        print((snapshot.progress?.completedUnitCount)!)
        self.loadingIndicatorView.isHidden = false
        self.loadingIndicatorView.startAnimating()
      }
      
      uploadTask.observe(.success) { (snapshot) in
        print("SUCCESS")
        self.loadingIndicatorView.stopAnimating()

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
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if photo_or_video == "photo"{
      if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        images.append(image)
        indexImage += 1
        
        uploadingImage(img: UIImageView(image: image)) { (url) in
          print("URLLLLLLL: " + url)
          self.image_downloadUrlList.append(url)
        }
        imageCollectionview.reloadData()
        
      }
    } else if photo_or_video == "video"{
      
      if let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
        
        indexVideo += 1
        let storageReference = self.videoRef.child("video-\(indexVideo).mov")
        
        let uploadTask = storageReference.putFile(from: videoURL as URL, metadata: nil, completion: { (metadata, error) in
          if error == nil {
            storageReference.downloadURL(completion: { (url, error) in
              self.video_downloadUrlList.append("\(url!)")
              print("Here's the file URL: ", "\(url!)")
              if let thumbnailImage = self.thumbnailImageFOrVideoUrl(url! as NSURL){
                self.videoScreenImageList.append(thumbnailImage)
                print(self.videoScreenImageList.count)
                self.videoCollectionView.reloadData()
                
              }
            })
          } else {
            print(error!.localizedDescription)
          }
        })
        uploadTask.observe(.progress) { (snapshot) in
          print((snapshot.progress?.completedUnitCount)!)
          self.loadingIndicatorView.isHidden = false
          self.loadingIndicatorView.startAnimating()
        }
        uploadTask.observe(.success) { (snapshot) in
          self.videoCollectionView.reloadData()
          print("SUCCESS")
          self.loadingIndicatorView.stopAnimating()

        }
      }
      
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  
  
  @IBAction func openDatePicker(_ sender: UIButton) {
    self.view.endEditing(true)
    self.pickerView.isHidden = false
    self.timeSeperatorView.backgroundColor = UIColor.gray
    self.dateSeperatorView.backgroundColor = UIColor.gray
    
    if sender.tag == 0{
      self.pickerType = "Date"
      self.dateSeperatorView.backgroundColor = UIColor.black
      self.timePicker.isHidden = true
      self.datePicker.isHidden = false
    }else{
      self.pickerType = "Time"
      self.timeSeperatorView.backgroundColor = UIColor.black
      self.timePicker.isHidden = false
      self.datePicker.isHidden = true
    }
    UIView.animate(withDuration: 0.5) {
      self.pickerView.frame.origin.y = UIScreen.main.bounds.height - self.pickerView.frame.height
    }
    
    
  }
  
  @IBAction func pickkerBtn(_ sender: UIButton) {
    self.timeSeperatorView.backgroundColor = UIColor.gray
    self.dateSeperatorView.backgroundColor = UIColor.gray
    
    if sender.tag == 1{
      if pickerType == "Date"{
        let components = Calendar.current.dateComponents([.year, .month, .day], from: (datePicker as AnyObject).date)
        
        
        self.dateTF.text = "\(components.day!).\(components.month!).\(components.year!)"
      }else if pickerType == "Time"{
        let components = Calendar.current.dateComponents([.hour, .minute], from: (timePicker as AnyObject).date)
        
        self.timeTF.text = "\(components.hour!):\(components.minute!)"
      }
      

      
      
      UIView.animate(withDuration: 0.5) {
        self.pickerView.frame.origin.y = UIScreen.main.bounds.height
      }
      
    }else{
      UIView.animate(withDuration: 0.5) {
        self.pickerView.frame.origin.y = UIScreen.main.bounds.height
      }
    }
  }
}

extension NewMemoryViewController{
  func addMemoryInFirebase(complation: @escaping () -> ()) {
    let group = DispatchGroup()
    let key = refMemory.childByAutoId().key
    let memories = ["id": key,
                    "memory": newMemoryTextView.text! as String,
                    "date": dateTF.text! as String,
                    "time" :timeTF.text! as String]
    
    refMemory.child(key).setValue(memories)
    
    var dictionaryImages = [String: String]()
    
    image_downloadUrlList.forEach { (url) in
      group.enter()
      dictionaryImages["\(dictionaryImages.count)"] = url
      group.leave()
      
    }
    
    group.notify(queue: .main) {
      self.refMemory.child(key).child("ImageUrls").setValue(dictionaryImages) { (error, ref) in
        
        complation()
      }
    }
    
    var dictionaryVideo = [String: String]()
    
    video_downloadUrlList.forEach { (url) in
      group.enter()
      dictionaryVideo["\(dictionaryVideo.count)"] = url
      group.leave()
    }
    
    group.notify(queue: .main) {
      self.refMemory.child(key).child("VideoUrls").setValue(dictionaryVideo) { (error, ref) in
        
        complation()
        
      }
      
      
    }
  }
}

extension NewMemoryViewController{
  func textView(_ newMemoryTextView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    let currentText:String = newMemoryTextView.text
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
    
    if updatedText.isEmpty {
      
      newMemoryTextView.text = "Новое воспоминание"
      newMemoryTextView.textColor = UIColor.lightGray
      
      newMemoryTextView.selectedTextRange = newMemoryTextView.textRange(from: newMemoryTextView.beginningOfDocument, to: newMemoryTextView.beginningOfDocument)
    }
      
    else if newMemoryTextView.textColor == UIColor.lightGray && !text.isEmpty {
      newMemoryTextView.textColor = UIColor.black
      newMemoryTextView.text = text
    }
    else {
      return true
    }
    return false
  }
  
  func textViewDidChangeSelection(_ newMemoryTextView: UITextView) {
    if self.view.window != nil {
      if newMemoryTextView.textColor == UIColor.lightGray {
        newMemoryTextView.selectedTextRange = newMemoryTextView.textRange(from: newMemoryTextView.beginningOfDocument, to: newMemoryTextView.beginningOfDocument)
      }
    }
  }
}


extension NewMemoryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.tag == 0{
      return images.count
    }else{
      return videoScreenImageList.count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.tag == 0{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImagesCollectionViewCell
      
      cell.imagesView.image = images[indexPath.item]
      
      return cell
    }else{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideosCollectionViewCell
      
      cell.videoView.image = videoScreenImageList[indexPath.item]
      
      return cell
      
    }
    
    
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView.tag == 0{
      return 10
    }else{
      return 10
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    UIView.animate(withDuration: 0.5) {
      self.pickerView.frame.origin.y = UIScreen.main.bounds.height
    }
  }
  
  
  
}

