//
//  ChangeInformCell.swift
//  Memories
//
//  Created by Eldor Makkambayev on 24.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit

class ChangeInformCell: UITableViewCell {

  var format = 0
  
  @IBOutlet weak var barCollectionView: UICollectionView!
  
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ChangeInformCell{
  func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate: D, forRow row: Int){
    barCollectionView.delegate = dataSourceDelegate
    barCollectionView.dataSource = dataSourceDelegate
    
    barCollectionView.reloadData()
  }
}
