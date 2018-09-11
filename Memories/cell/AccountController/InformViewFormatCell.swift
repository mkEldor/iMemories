//
//  InformViewFormatCell.swift
//  Memories
//
//  Created by Eldor Makkambayev on 24.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit

class InformViewFormatCell: UICollectionViewCell {
  @IBOutlet weak var memoryText: UITextView!
  @IBOutlet weak var memoryView: UIView!
  
  override func awakeFromNib() {
    super .awakeFromNib()
    memoryView.layer.borderColor = UIColor.lightGray.cgColor
    memoryView.layer.borderWidth = 0.5
    memoryView.clipsToBounds = true
    
    memoryText.textColor = UIColor.lightGray
  }
}
