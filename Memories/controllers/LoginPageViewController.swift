//
//  ViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 19.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
@IBDesignable

class LoginPageViewController: UIViewController {
  
  @IBOutlet weak var avataricon: UIImageView!
  @IBOutlet weak var seperatorView: UIView!
  
  
  @IBOutlet weak var additionalView: UIView!
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var signInActionBtn: UIButton!
  @IBOutlet weak var registerbtn: UIButton!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var signInIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var signUpIndicatorView: UIActivityIndicatorView!
  
  
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var repeatPasswordTF: UITextField!
  @IBOutlet weak var nameAndSurnameTF: UITextField!
  
  var auth: Auth!
  var database: Database!
  
  var y1: CGFloat?
  var y2: CGFloat?
  var mainViewOrient: CGFloat?
  var additionalViewOrient: CGFloat?
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    do{
//      try Auth.auth().signOut()
//    }catch{
//
//    }
    auth = Auth.auth()
    database = Database.database()
    
    let current_user = auth.currentUser
    if current_user == nil{
      
    }else {
      performSegue(withIdentifier: "signIn", sender: self)
    }
    
    
    
    
    y1 = signInActionBtn.frame.origin.y
    y2 = registerbtn.frame.origin.y
    mainViewOrient = mainView.frame.origin.y
    additionalViewOrient = additionalView.frame.origin.y
    
    
    downUpView()
  }
  
  
  @IBAction func loginTapped(_ sender: UIButton) {
    sender.setTitle("", for: .normal)
    signInIndicatorView.startAnimating()
    Auth.auth().signIn(withEmail: nameTF.text!, password: passwordTF.text!, completion: { (user, error) in
      self.signInIndicatorView.stopAnimating()
      sender.setTitle("Войти", for: .normal)
      if error == nil{
        if (user?.user.isEmailVerified)!{
          let reference: DatabaseReference! = Database.database().reference().child("Users").child((user?.user.uid)!)
          
          reference.queryOrderedByKey().observe(.value, with: { [weak self] (snapshot) in
            if snapshot.childrenCount > 0 {
              
              let snapshotValue: [String: AnyObject] = snapshot.value as! [String: AnyObject]
              
              var userData: [String : Any] = [String : Any]()
              userData["userId"] = snapshotValue["userId"]
              userData["userEmail"] = snapshotValue["userEmail"]
              UserDefaults.standard.set(userData, forKey: "userData")
              
              self?.performSegue(withIdentifier: "signInMain", sender: self)
              
            }
          })
        }
        else{
          ToastView.shared.short(self.view, txt_msg: "Ваш адрес электронной почты не подтвержден!")
          print(" Your email is not verified! ")
        }
      }else{
        ToastView.shared.short(self.view, txt_msg: "Ошибка! Пользователь не зарегистрирован.")
        print("Error! User is not signed up.")
      }
    })
  }
  
  
  @IBAction func createAccountTapped(_ sender: UIButton) {
    sender.setTitle("", for: .normal)
    signUpIndicatorView.startAnimating()
    Auth.auth().createUser(withEmail: nameTF.text!, password: passwordTF.text!, completion: { (user, error) in
      self.signUpIndicatorView.stopAnimating()
      sender.setTitle("Зарегистрироваться", for: .normal)
      
      if error == nil && self.nameAndSurnameTF.text != nil && self.passwordTF.text == self.repeatPasswordTF.text{
        user?.user.sendEmailVerification(completion: { (error) in
          if error == nil {
            let reference: DatabaseReference! = Database.database().reference().child("Users").child((user?.user.uid)!)
            var userDataRemote: [String : AnyObject] = [String : AnyObject]()
            userDataRemote["userId"] = (user?.user.uid)! as AnyObject
            userDataRemote["userEmail"] = (user?.user.email)! as AnyObject
            userDataRemote["username"] = self.nameAndSurnameTF.text as AnyObject
            
            reference.updateChildValues(userDataRemote) { (err, ref) in
              if err != nil {
                print("err： \(err!)")
                return
              }
            }
            
            ToastView.shared.long(self.view, txt_msg: "Проверьте свою электронную почту. Мы отправили вам ссылку для подтверждения.")
            
            self.view.isUserInteractionEnabled = true
            self.signInButtonAnimation()
          }
          
        })
        
        

        
      }else if self.passwordTF.text != self.repeatPasswordTF.text{
        ToastView.shared.short(self.view, txt_msg: "Пароли не совпадают.")
      }else{
        ToastView.shared.short(self.view, txt_msg: "Что-то не так!")
      }
    })
  }
  
  
  
  @IBAction func buttonActions(_ sender: UIButton) {
    
    if sender.tag == 0{
      signInButtonAnimation()
    }else{
      signUpButtonAnimation()
    }
    
    clearAllTextField()
    
  }
  
  func downUpView(){
    NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification) in
      self.view.bounds.origin.y = 150
    }
    
    NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification) in
      self.view.bounds.origin.y = 0
    }
  }
  
  func clearAllTextField(){
    
    nameTF.text = ""
    passwordTF.text = ""
    repeatPasswordTF.text = ""
    nameAndSurnameTF.text = ""
  }
  
  func signInButtonAnimation(){
    signInButton.alpha = 1
    signUpButton.alpha = 0.5
    UIView.animate(withDuration: 0.5) {
      self.additionalView.alpha = 0
      self.signInActionBtn.alpha = 1
      self.registerbtn.frame.origin.y = 0
      self.signInActionBtn.frame.origin.y = self.y1!
      self.mainView.frame.origin.y = self.mainViewOrient!
      self.additionalView.frame.origin.y = self.additionalViewOrient!
      self.avataricon.alpha = 0
      self.seperatorView.alpha = 0
      self.nameAndSurnameTF.alpha = 0
    }
  }
  
  func signUpButtonAnimation(){
    signUpButton.alpha = 1
    signInButton.alpha = 0.5
    UIView.animate(withDuration: 0.5) {
      self.additionalView.alpha = 1
      self.signInActionBtn.alpha = 0
      self.signInActionBtn.frame.origin.y = self.additionalView.frame.origin.y + self.y2!
      self.registerbtn.frame.origin.y = self.y2!
      self.mainView.frame.origin.y = self.mainViewOrient! + 77
      self.additionalView.frame.origin.y = self.additionalViewOrient! + 77
      self.avataricon.alpha = 1
      self.seperatorView.alpha = 1
      self.nameAndSurnameTF.alpha = 1
      
    }
  }
  
  
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  
}

