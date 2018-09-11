//
//  NotesCell.swift
//  Memories
//
//  Created by Eldor Makkambayev on 24.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {

  @IBOutlet weak var note_view: UIView!
  @IBOutlet weak var noteTitleText: UILabel!
  @IBOutlet weak var noteText: UITextView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    note_view.layer.cornerRadius = 13
    note_view.layer.borderColor = UIColor.black.cgColor
    note_view.layer.borderWidth = 2
    
    
    }
  
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
 
  

}
