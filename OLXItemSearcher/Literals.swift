//
//  Literals.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/5/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import Foundation

struct Literals {
  
  static let loading = "Loading"
  static let connectionError = "Connect failure. Please try again."
  static let searchForItems = "Search for Items"
  static let dislikeItemConfirmMessage = "Do you want to remove this item?"
  static let deleteButton = "Delete"
  static let cancelButton = "Cancel"
  
  struct ImageNames {
    static let likeButton = "LikeButton"
    static let dislikeButton = "DislikeButton"
    static let imagePlaceholder = "ImageNotLoadedPlaceholder"
    static let clearButton = "ClearButton"
  }
  
  struct Observers {
    static let itemDidChange = Notification.Name(rawValue: "itemDidChange")
  }
  
  struct Segues {
    static let itemDetail = "itemDetail"
  }
  
}
