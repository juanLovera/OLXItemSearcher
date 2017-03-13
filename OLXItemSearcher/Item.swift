//
//  Item.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/7/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import Foundation

struct Item {
  
  typealias Optional = (label: String, value: String)
  
  var descriptionText: String
  var title: String
  var condition: String
  var id: Int64
  var date: Date
  var thumbnailURL: String
  var fullImageURL: String
  var displayPrice: String
  var location: String
  var optionals: [Optional]
  
}

extension Item : Equatable {
  
  static func == (left: Item, right: Item) -> Bool {
    return left.id == right.id
  }
  
}
