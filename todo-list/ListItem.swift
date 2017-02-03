//
//  ListItem.swift
//  todo-list
//
//  Created by Madhusudhan Sambojhu on 03/02/17.
//  Copyright © 2017 Madhusudhan Sambojhu. All rights reserved.
//

import Foundation
import UIKit

class ListItem {
  static var instanceCount: Int = 0
  
  var name: String = ""
  var isCompleted: Bool = false
  var id: Int = -1
  var itemColor: UIColor = UIColor.red
  
  static func makeItem(with name:String, color: UIColor) -> ListItem {
    ListItem.instanceCount = ListItem.instanceCount + 1
    let listItem = ListItem()
    listItem.name = name
    listItem.id = ListItem.instanceCount
    listItem.isCompleted = false
    listItem.itemColor = color
    return listItem
  }
}
