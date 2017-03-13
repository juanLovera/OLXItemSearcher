//
//  ScrollView.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/9/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit

extension UIScrollView {
  
  func isFullyScrolled() -> Bool {
    let offset = self.contentOffset
    let bounds = self.bounds
    let size = self.contentSize
    let inset = self.contentInset
    let offsetConverted = offset.y + bounds.size.height - inset.bottom
    if offsetConverted > size.height {
      return true
    }
    return false
  }
  
}
