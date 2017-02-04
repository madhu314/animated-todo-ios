//
//  ListViewController.swift
//  todo-list
//
//  Created by Madhusudhan Sambojhu on 03/02/17.
//  Copyright © 2017 Madhusudhan Sambojhu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var collectionView: UICollectionView!
  
  var movingCell: ListItemCell?
  var movementStartLocation: CGPoint?
  var listItemDataset: ListItemDataset = ListItemDataset()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
    self.collectionView.addGestureRecognizer(longPressGesture)
    
    let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let gridSpacing: CGFloat = 10
    collectionViewLayout.minimumInteritemSpacing = 0
    collectionViewLayout.minimumLineSpacing = gridSpacing
    collectionViewLayout.sectionInset = UIEdgeInsets(top: 4 * gridSpacing, left: 2 * gridSpacing, bottom: gridSpacing, right: 2 * gridSpacing)
    
    let width: CGFloat = collectionView.frame.width
    let height: CGFloat = 80
    
    collectionViewLayout.itemSize = CGSize(width: width - (4 * gridSpacing), height: height)
    collectionView.register(UINib(nibName: "ListItemCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    listItemDataset.generateRandom()
  }
  
  func handleLongGesture(gesture: UILongPressGestureRecognizer) {
    
    switch(gesture.state) {
      
    case .began:
      movementStartLocation = gesture.location(in: collectionView)
      if let indexPath = self.collectionView.indexPathForItem(at: movementStartLocation!) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! ListItemCell
        movingCell = cell
        collectionView.beginInteractiveMovementForItem(at: indexPath)
        self.decorateReadyToMove(for: cell, withElevation: 8, andAngle: 0.0)
      }
    case .changed:
      let changedTo: CGPoint = gesture.location(in: collectionView)
      collectionView.updateInteractiveMovementTargetPosition(changedTo)
      if let cell = movingCell {
        decorateReadyToMove(for: cell, withElevation: 8, andAngle: (changedTo.y - movementStartLocation!.y > 0) ? 2.0 : -2.0)
        movementStartLocation = changedTo
      }
    case .ended:
      if let cell = self.movingCell {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
          self.decorateResting(for: cell)
        }, completion: { (completed) in
          
        })
      }
      collectionView.endInteractiveMovement()
    default:
      collectionView.cancelInteractiveMovement()
      UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
        if let cell = self.movingCell {
          self.decorateResting(for: cell)
        }
      }, completion: { (completed) in
        
      })
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listItemDataset.size()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! ListItemCell
    cell.transform = CGAffineTransform(scaleX: 1, y: 1)
    let listItem = listItemDataset.item(at: indexPath.row)
    cell.label.text = listItem.name
    cell.colorMarkerView.backgroundColor = listItem.itemColor
    cell.listItem = listItem
    
    cell.completedClosure = { listItem in
      cell.leadingConstraint.constant = 0
      cell.trailingConstraint.constant = 0
      UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
        self.decorateReadyToMove(for: cell, withElevation: 8, andAngle: 0.0)
        cell.layoutIfNeeded()
      }, completion: { (completed) in
        if(listItem.isCompleted) {
          cell.trailingConstraint.constant = cell.frame.width - 4
          self.decorateResting(for: cell)
        } else {
          cell.leadingConstraint.constant = cell.frame.width - 4
          self.decorateCompleted(for: cell)
        }
        self.listItemDataset.toggleCompleted(forItem: listItem, on: self.collectionView)
      })
    }
    
    cell.deletedClosure = { listItem in
      UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
        self.decorateReadyToMove(for: cell, withElevation: 4, andAngle: 0)
        cell.transform = CGAffineTransform(scaleX: 0.01, y: 1)
      }, completion: { (completed) in
        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.listItemDataset.remove(item: listItem, on: self.collectionView)
      })
    }
    
    if listItem.isCompleted {
      decorateCompleted(for: cell)
    } else {
      decorateResting(for: cell)
    }
    
    if listItem.isCompleted {
      cell.leadingConstraint.constant = cell.frame.width - 4
      cell.trailingConstraint.constant = 0
    } else {
      cell.leadingConstraint.constant = 0
      cell.trailingConstraint.constant = cell.frame.width - 4
    }
    cell.updateConstraints()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    listItemDataset.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
  }
  
  func decorateReadyToMove(for view: UIView, withElevation elevation: CGFloat, andAngle angle: CGFloat?) {
    view.backgroundColor = UIColor.white
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: elevation)
    view.layer.shadowOpacity = 0.24
    view.layer.shadowRadius = elevation
    view.layer.borderColor = UIColor.darkGray.cgColor
    view.layer.borderWidth = 0
    if let _ = angle {
      movingCell?.layer.transform = CATransform3DMakeRotation(CGFloat(Double(angle!)*Double.pi/180.0), 0, 0, 1.0)
    } else {
      movingCell?.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1.0)
    }
    view.layer.shouldRasterize = true
    view.layer.rasterizationScale = UIScreen.main.scale
    view.layer.opacity = 1
  }
  
  func decorateResting(for view:UIView) {
    view.backgroundColor = UIColor.white
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    view.layer.shadowOpacity = 0.24
    view.layer.shadowRadius = 2.0
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.borderWidth = 0
    view.layer.opacity = 1
    movingCell?.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1.0)
  }
  
  func decorateCompleted(for view:UIView) {
    view.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.9)
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    view.layer.shadowOpacity = 0.24
    view.layer.shadowRadius = 2.0
    movingCell?.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1.0)
  }
  
  static func newInstance() -> ListViewController {
    return ListViewController(nibName: "ListViewController", bundle: nil)
  }
}
