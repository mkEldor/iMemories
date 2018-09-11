//
//  PinCodViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 20.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit
import LocalAuthentication
import RealmSwift
import AVFoundation
import AudioToolbox
import FirebaseAuth



class PinCodViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var txtOTP4: UITextField!
  @IBOutlet weak var txtOTP3: UITextField!
  @IBOutlet weak var txtOTP2: UITextField!
  @IBOutlet weak var txtOTP1: UITextField!
  var get = ""
  var passwordText = ""
  var pinCodeArray:Results<PinCodeModel>?
  let realm = try!Realm()
  
  var bool: Bool? = false
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
   
      textFieldAnimation()
    
    pinCodeArray = realm.objects(PinCodeModel.self)
    let modelItem = pinCodeArray![0]
    get = modelItem.pincode
    
    print(get)
    
  }
  
  func addBottomBorderTo(textField:UITextField) {
    
    let layer = CALayer()
    layer.backgroundColor = UIColor.white.cgColor
    layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
    textField.layer.addSublayer(layer)
    
  }
  @objc func textFieldDidChange(textField: UITextField){
    let text = textField.text
    if text?.utf16.count == 1{
      switch textField{
      case txtOTP1:
        txtOTP2.becomeFirstResponder()
      case txtOTP2:
        txtOTP3.becomeFirstResponder()
      case txtOTP3:
        txtOTP4.becomeFirstResponder()
      case txtOTP4:
        txtOTP4.resignFirstResponder()
        showMainMenu()
        
      default:
        break
      }
      
    }
    else{
      
    }
  }
 
  
  func showMainMenu(){
    passwordText = txtOTP1.text! + txtOTP2.text! + txtOTP3.text! + txtOTP4.text!
    if passwordText == get{
      performSegue(withIdentifier: "showMe", sender: nil)
    }else{
      AudioServicesPlaySystemSound(SystemSoundID(4095))
      txtOTP1.text! = ""
      txtOTP2.text! = ""
      txtOTP3.text! = ""
      txtOTP4.text! = ""
      printPinCode()
    }
    
  }
  
  
  
  func textFieldAnimation(){
    
    printPinCode()
    
    txtOTP1.backgroundColor = UIColor.clear
    txtOTP2.backgroundColor = UIColor.clear
    txtOTP3.backgroundColor = UIColor.clear
    txtOTP4.backgroundColor = UIColor.clear
    
    addBottomBorderTo(textField: txtOTP1)
    addBottomBorderTo(textField: txtOTP2)
    addBottomBorderTo(textField: txtOTP3)
    addBottomBorderTo(textField: txtOTP4)
    
    txtOTP1.delegate = self
    txtOTP2.delegate = self
    txtOTP3.delegate = self
    txtOTP4.delegate = self

  }
  
  func printPinCode(){
    txtOTP1.becomeFirstResponder()
    
    txtOTP1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    txtOTP2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    txtOTP3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    txtOTP4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
  }
  
  
  
  @IBAction func logOutAction(_ sender: UIButton) {
    do{
      try Auth.auth().signOut()
    }catch{
      
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainVC = storyboard.instantiateViewController(withIdentifier: "mainVC") as? LoginPageViewController
    
    self.present(mainVC!, animated: true, completion: nil)
  }
  
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
