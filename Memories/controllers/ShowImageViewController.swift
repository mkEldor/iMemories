//
//  ShowImageViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 08.08.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {
  var image: [UIImage] = []
  var index = 0
  var x : CGFloat?
  @IBOutlet weak var imageView: UIImageView!
  override func viewDidLoad() {
        super.viewDidLoad()
    x = imageView.frame.origin.x
    swipe()
    imageView.image = image[index]
    
        // Do any additional setup after loading the view.
    }
  
  func swipe(){
    imageView.isUserInteractionEnabled = true
    let swiftRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
    swiftRight.direction = UISwipeGestureRecognizerDirection.right
    imageView.addGestureRecognizer(swiftRight)
    
    let swiftLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))// #selector(self.swipeGesture))
    swiftLeft.direction = UISwipeGestureRecognizerDirection.left
    imageView.addGestureRecognizer(swiftLeft)
    
    let swiftUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))// #selector(self.swipeGesture))
    swiftUp.direction = UISwipeGestureRecognizerDirection.up
    imageView.addGestureRecognizer(swiftUp)
    
    let swiftDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))// #selector(self.swipeGesture))
    swiftDown.direction = UISwipeGestureRecognizerDirection.down
    imageView.addGestureRecognizer(swiftDown)
  }

  
  @objc func swipeGesture(sender: UIGestureRecognizer){
    if let swipeGesture = sender as? UISwipeGestureRecognizer{
      switch swipeGesture.direction{
      case UISwipeGestureRecognizerDirection.down:
        UIView.animate(withDuration: 0.5) {
          
          self.dismiss(animated: true, completion: {
            self.view.backgroundColor  = UIColor.clear
            self.imageView.backgroundColor = UIColor.clear
          })        }
        
      case UISwipeGestureRecognizerDirection.up:
        dismiss(animated: true, completion: nil)
      case UISwipeGestureRecognizerDirection.right:
        print(index)
        if index > 0{
          UIView.animate(withDuration: 0.5) {
            self.imageView.frame.origin.x = UIScreen.main.bounds.width + self.x!
          }
          self.imageView.frame.origin.x = 0.0 - x!
          UIView.animate(withDuration: 0.5) {
            self.imageView.frame.origin.x = self.x!
          }
          imageView.image = image[index-1]
          index -= 1
        }
      case UISwipeGestureRecognizerDirection.left:
        if (index + 1) != image.count{
        UIView.animate(withDuration: 0.5) {
          self.imageView.frame.origin.x = 0.0 - self.x!        }
        self.imageView.frame.origin.x = UIScreen.main.bounds.width + x!
        UIView.animate(withDuration: 0.5) {
          self.imageView.frame.origin.x = self.x!
        }
        
        print(index)
        imageView.image = image[index+1]
          index += 1
          
        }
      default:
        break
      }
    }
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
