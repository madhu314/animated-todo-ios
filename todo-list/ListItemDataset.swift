//
//  ListitemDataSource.swift
//  todo-list
//
//  Created by Madhusudhan Sambojhu on 03/02/17.
//  Copyright © 2017 Madhusudhan Sambojhu. All rights reserved.
//

import Foundation
import UIKit
class ListItemDataset {
  private var items: [ListItem] =  []

  func size() -> Int {
    return items.count
  }

  func item(at position: Int) -> ListItem {
    return items[position]
  }

  func moveItem(from fromPos: Int, to: Int) {
    let item = self.items.remove(at: fromPos)
    self.items.insert(item, at: to)
  }

  func remove(item: ListItem, on collectionView: UICollectionView) {
    let foundIndex = items.index { (given) -> Bool in
      return given.id == item.id
    }
    if let index = foundIndex {
      items.remove(at: index)
      collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
  }

  func toggleCompleted(forItem listItem: ListItem, on collectionView: UICollectionView) {
    let foundIndex = items.index { (given) -> Bool in
      return given.id == listItem.id
    }
    if(listItem.isCompleted) {
      if let index = foundIndex {
        let item = items.remove(at: index)
        items.insert(item, at: 0)
        item.isCompleted = false
        collectionView.moveItem(at: IndexPath(item: index, section: 0), to: IndexPath(item: 0, section: 0))
      }
    } else {
      if let index = foundIndex {
        let item = items.remove(at: index)
        items.append(item)
        item.isCompleted = true
        collectionView.moveItem(at: IndexPath(item: index, section: 0), to: IndexPath(item: items.count - 1, section: 0))
      }
    }
  }

  func generateRandom() {
    items.removeAll()

    items.append(ListItem.makeItem(with: "Pick up laundry", color: UIColor(red:0.93, green:0.54, blue:0.65, alpha:1.00)))
    items.append(ListItem.makeItem(with: "Finish design work", color: UIColor(red:0.69, green:0.62, blue:0.83, alpha:1.00)))
    items.append(ListItem.makeItem(with: "Call dad", color: UIColor(red:0.53, green:0.84, blue:0.96, alpha:1.00)))
    items.append(ListItem.makeItem(with: "Pay electricity bill", color: UIColor(red:0.48, green:0.77, blue:0.74, alpha:1.00)))
    items.append(ListItem.makeItem(with: "Book flight tickets", color: UIColor(red:0.66, green:0.81, blue:0.52, alpha:1.00)))

//    items.append(ListItem.makeItem(with: "Send that package", color: UIColor(red:0.98, green:0.71, blue:0.41, alpha:1.00)))
//    items.append(ListItem.makeItem(with: "Complete blog post", color: UIColor(red:0.50, green:0.35, blue:0.25, alpha:1.00)))
//    items.append(ListItem.makeItem(with: "Learn that new recipe", color: UIColor(red:0.30, green:0.42, blue:0.82, alpha:1.00)))
//    items.append(ListItem.makeItem(with: "Submit app for review", color: UIColor(red:0.83, green:0.27, blue:0.42, alpha:1.00)))
//    items.append(ListItem.makeItem(with: "Clear all PRs", color: UIColor(red:0.27, green:0.34, blue:0.40, alpha:1.00)))
  }
}
