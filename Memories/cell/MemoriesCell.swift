//
//  MemoriesCell.swift
//  Memories
//
//  Created by Eldor Makkambayev on 24.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit

class MemoriesCell: UICollectionViewCell {
  @IBOutlet weak var frameView: UIView!
  @IBOutlet weak var textLabel: UITextView!
  @IBOutlet weak var imageIcon: UIImageView!
  @IBOutlet weak var videoIcon: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  
  
  @IBOutlet weak var deleteButton: UIButton!
  override func awakeFromNib() {
    super .awakeFromNib()
    frameView.layer.borderColor = UIColor.lightGray.cgColor
    frameView.layer.borderWidth = 0.5
    frameView.clipsToBounds = true
    
    textLabel.textColor = UIColor.lightGray
  }
  
    
}
