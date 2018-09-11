//
//  AddPinCodViewController.swift
//  Memories
//
//  Created by Eldor Makkambayev on 02.08.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//


import UIKit
import LocalAuthentication
import RealmSwift
class AddPinCodViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var txt1: UITextField!
  @IBOutlet weak var txt2: UITextField!
  @IBOutlet weak var txt3: UITextField!
  @IBOutlet weak var txt4: UITextField!
  let realm = try!Realm()
  var newPinCod: String? = ""
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    textFieldAnimation()
    
  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    txt1.becomeFirstResponder()
    
  
  }
  
  
  @objc func textFieldDidChange(textField: UITextField){
    let text = textField.text
    if text?.utf16.count == 1{
      switch textField{
      case txt1:
        txt2.becomeFirstResponder()
      case txt2:
        txt3.becomeFirstResponder()
      case txt3:
        txt4.becomeFirstResponder()
      case txt4:
        txt4.resignFirstResponder()
        inOnetext()

      default:
        break
      }
      
    }
    else{
      
    }
  }
  
  
  
  func addBottomBorderTo(textField:UITextField) {

    let layer = CALayer()
    layer.backgroundColor = UIColor.white.cgColor
    layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
    textField.layer.addSublayer(layer)

  }
  
  func inOnetext(){
    newPinCod = txt1.text! + txt2.text! + txt3.text! + txt4.text!
    saveToCoreData()
   performSegue(withIdentifier: "repeatPinCodID", sender: nil)
    
  }
  
  func saveToCoreData(){
    let pinCode = PinCodeModel()
    
    try! self.realm.write {
      self.realm.deleteAll()
    }

    pinCode.pincode = newPinCod!
    try! self.realm.write {
      self.realm.add(pinCode)
    }
  }
  
 
  
  func textFieldAnimation(){
    
    txt1.backgroundColor = UIColor.clear
    txt2.backgroundColor = UIColor.clear
    txt3.backgroundColor = UIColor.clear
    txt4.backgroundColor = UIColor.clear
    
    addBottomBorderTo(textField: txt1)
    addBottomBorderTo(textField: txt2)
    addBottomBorderTo(textField: txt3)
    addBottomBorderTo(textField: txt4)
    
    txt1.delegate = self
    txt2.delegate = self
    txt3.delegate = self
    txt4.delegate = self
    
    txt1.becomeFirstResponder()
    
    txt1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    txt2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    txt3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    txt4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
  }
  
  
  func touchID(){
    
    let authenticationObject: LAContext = LAContext()
    
    if authenticationObject.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
      authenticationObject.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Требуется авторизация через сканер отпечатков!", reply: { (Bool, error) in
        if Bool{
          print("correct")
        }else{
          print("Incorrect")
        }
      })
      
    }else{
      
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
