//
//  ItemDetailViewController.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/12/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit
import Haneke

class ItemDetailViewController: UIViewController {
  
  @IBOutlet weak var likeButton: UIBarButtonItem!
  @IBOutlet weak var condition: UILabel!
  @IBOutlet weak var descriptionText: UITextView!
  @IBOutlet weak var diplayPrice: UILabel!
  @IBOutlet weak var titleText: UILabel!
  @IBOutlet weak var picture: UIImageView!
  @IBOutlet weak var pictureHeightConstraint: NSLayoutConstraint!
  var item: Item!
  var itemPicture: UIImage?
  private var maxPictureHeight: CGFloat!
  private let closeImageAfterHeightPercentage: CGFloat = 0.75
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    maxPictureHeight = pictureHeightConstraint.constant
  }
  
  private func prepareUI() {
    removerNavBarSeparator()
    fetchImageIfNeededAndFill()
    fillItemData()
  }
  
  private func fetchImageIfNeededAndFill() {
    if itemPicture == nil {
      if let fullImageURL = URL(string: item.fullImageURL) {
        picture?.hnk_setImage(from: fullImageURL)
      }
    } else {
      picture.image = itemPicture!
    }
  }
  
  private func fillItemData() {
    titleText.text = item.title
    diplayPrice.text = item.displayPrice
    descriptionText.text = item.descriptionText
    condition.text = item.location
    if FavoriteManager.isItemOnFavorites(item: item) {
      putDislikeButton()
    }
  }
  
  private func removerNavBarSeparator() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  @IBAction func toggleFavorite(_ sender: Any) {
    if !FavoriteManager.isItemOnFavorites(item: item) {
      if FavoriteManager.addItemToFavorites(item: item) {
        putDislikeButton()
      }
    } else {
      if FavoriteManager.deleteItemFromFavorites(item: item) {
        putLikeButton()
      }
    }
  }
  
  private func putLikeButton() {
    likeButton.image = UIImage(named: Literals.ImageNames.likeButton)
  }
  
  private func putDislikeButton() {
    likeButton.image = UIImage(named: Literals.ImageNames.dislikeButton)
  }
  
  @IBAction func userDidScroll(_ sender: UIPanGestureRecognizer) {
    let yTranslation = sender.translation(in: view).y
    var newHeight = pictureHeightConstraint.constant + yTranslation
    newHeight = max(0, min(maxPictureHeight, newHeight))
    if newHeight < maxPictureHeight * closeImageAfterHeightPercentage {
      if (yTranslation < 0) {
        animateImageHeight(constant: 0)
      } else {
        animateImageHeight(constant: maxPictureHeight * closeImageAfterHeightPercentage)
      }
      return
    }
    pictureHeightConstraint.constant = newHeight
    sender.setTranslation(CGPoint.zero, in: view)
  }
  
  private func animateImageHeight(constant: CGFloat) {
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   options: .curveLinear,
                   animations: { () -> Void in
                    self.pictureHeightConstraint.constant = constant
                    self.view.layoutIfNeeded()
    }, completion: nil)
  }

}
