//
//  AccountInformCell.swift
//  Memories
//
//  Created by Eldor Makkambayev on 24.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit

class AccountInformCell: UITableViewCell {
  
  @IBOutlet weak var memoriesCountLabel: UILabel!
  @IBOutlet weak var notesCountLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
  }
  
  @objc func openImagePickker(_ sender: Any){
//    self.present(imagePicker, animated: true, completion: nil)
  }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
