//
//  DateFormatter.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/7/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import Foundation

class DateFormatterManager {
 
  static let sharedInstance = DateFormatterManager()
  
  let iso8601Formatter = DateFormatter()
  
  init() {
    iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
  }
  
}
