//
//  ListItemCell.swift
//  todo-list
//
//  Created by Madhusudhan Sambojhu on 03/02/17.
//  Copyright © 2017 Madhusudhan Sambojhu. All rights reserved.
//

import UIKit

class ListItemCell: UICollectionViewCell {
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var completeButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

  @IBOutlet weak var colorMarkerView: UIView!
  @IBOutlet weak var trailingConstraint: NSLayoutConstraint!

  var listItem: ListItem?
  var completedClosure: ((ListItem) -> Void)?
  var deletedClosure: ((ListItem) -> Void)?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    var image = UIImage(named: "ic_close_white")?.withRenderingMode(.alwaysTemplate)
    deleteButton.setImage(image, for: .normal)
    deleteButton.tintColor = UIColor.lightGray

    image = UIImage(named: "ic_check_white")?.withRenderingMode(.alwaysTemplate)
    completeButton.setImage(image, for: .normal)
    completeButton.tintColor = UIColor.lightGray

    deleteButton.addTarget(self, action: #selector(itemDeleted), for: .touchUpInside)
    completeButton.addTarget(self, action: #selector(itemCompleted), for: .touchUpInside)
  }

  func itemCompleted() {
    if let item = listItem {
      if let closure = completedClosure {
        closure(item)
      }
    }
  }

  func itemDeleted() {
    if let item = listItem {
      if let closure = deletedClosure {
        closure(item)
      }
    }
  }

}
