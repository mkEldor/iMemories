//
//  Extensions.swift
//  Memories
//
//  Created by Eldor Makkambayev on 25.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import Foundation
extension UIColor{
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
}

extension UIView{
  func addConstraintsWithFormat(format: String, views: UIView...){
    var viewDictionary = [String:UIView]()
    
    for (index, view) in views.enumerated(){
      let key = "v\(index)"
      viewDictionary[key] = view
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
  }
}
