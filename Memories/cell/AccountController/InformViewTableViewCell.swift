//
//  InformViewTableViewCell.swift
//  Memories
//
//  Created by Eldor Makkambayev on 24.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import UIKit


class InformViewTableViewCell: UITableViewCell {
  
  
  
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var notesTableView: UITableView!
  
  var reload: Bool?{
    didSet{
      self.notesTableView.reloadData()
      self.collectionView.reloadData()
    }
  }
  var screenSize: CGRect!
  var screenWidth: CGFloat!
  var screenHeight: CGFloat!
  var formatFromAccountPage = 0
  
  let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
  let itemsPerRow: CGFloat = 3
  
  fileprivate var longPressGesture: UILongPressGestureRecognizer!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
    collectionView.addGestureRecognizer(longPressGesture)
    
   inFormatZeroOrOne()

    NotificationCenter.default.addObserver(self, selector: #selector(setFormatNumber), name: Notification.Name.init("Qwerty"), object: nil)
  }
  
  @objc func setFormatNumber(formatNumber: Notification) -> Void {
    self.formatFromAccountPage = formatNumber.object as! Int
    print("FORMAT_PAGE")
    print(formatFromAccountPage)
    
    if formatFromAccountPage == 2{
      notesTableView.isHidden = false
    }else{
      notesTableView.isHidden = true
      collectionView.isHidden = false
    }
  }
  
  func inFormatZeroOrOne(){
    screenSize = UIScreen.main.bounds
    screenWidth = screenSize.width
    screenHeight = screenSize.height
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: screenWidth/1 , height: screenWidth/2)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    collectionView!.collectionViewLayout = layout
    collectionView.reloadData()
  }
  
  
  @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
    switch(gesture.state) {
      
    case .began:
      guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
        break
      }
      
      collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
    case .changed:
      collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
    case .ended:
      collectionView.endInteractiveMovement()
    default:
      collectionView.cancelInteractiveMovement()
      
    }
  }
  
  
  
}


extension InformViewTableViewCell{
  func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate: D, forRow row: Int){
    collectionView.delegate = dataSourceDelegate
    collectionView.dataSource = dataSourceDelegate
    collectionView.reloadData()
  }
}


