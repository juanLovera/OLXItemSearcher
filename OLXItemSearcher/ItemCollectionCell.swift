//
//  ItemCollectionCell.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/8/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit

class ItemCollectionCell : UICollectionViewCell {
  
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var price: UILabel!

  func putLikeButton() {
    let buttonImage = UIImage(named: Literals.ImageNames.likeButton)
    likeButton.setImage(buttonImage, for: .normal)
  }
  
  func putDislikeButton() {
    let buttonImage = UIImage(named: Literals.ImageNames.dislikeButton)
    likeButton.setImage(buttonImage, for: .normal)
  }
  
  static func populateCell(cell: ItemCollectionCell, item: Item) {
    cell.title.text = item.title
    cell.price.text = item.displayPrice
    if let thumbnailURL = URL(string: item.thumbnailURL) {
      cell.image.hnk_setImage(from: thumbnailURL)
      cell.image.contentMode = .scaleAspectFill
      cell.image.clipsToBounds = true
    }
    if FavoriteManager.isItemOnFavorites(item: item) {
      cell.putDislikeButton()
    } else {
      cell.putLikeButton()
    }
    putShadowOnCell(cell: cell)
  }
  
  static func populateCell(cell: ItemCollectionCell, item: ItemPersistent) {
    cell.title.text = item.title
    cell.price.text = item.displayPrice
    if let imageData = item.fullImageData {
      let image = UIImage(data: imageData as Data)
      let imageView = cell.image
      imageView?.image = image
      imageView?.contentMode = .scaleAspectFill
      imageView?.clipsToBounds = true
    } else {
      cell.image.image = UIImage(named: Literals.ImageNames.imagePlaceholder)
    }
    cell.putDislikeButton()
    putShadowOnCell(cell: cell)
  }
  
  static func putShadowOnCell(cell: UICollectionViewCell) {
    cell.layer.shadowColor = UIColor.lightGray.cgColor
    cell.layer.shadowOffset = CGSize.zero
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 0.4
    cell.layer.masksToBounds = false
  }
}
