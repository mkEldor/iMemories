//
//  NotesFromAccountCVCell.swift
//  Memories
//
//  Created by Eldor Makkambayev on 03.08.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit

class NotesFromAccountCVCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var noteView: UIView!
  @IBOutlet weak var noteText: UITextView!
  
  override func awakeFromNib() {
    super .awakeFromNib()
    noteView.layer.cornerRadius = 13
    noteView.layer.borderColor = UIColor.black.cgColor
    noteView.layer.borderWidth = 2
  }
  
}
