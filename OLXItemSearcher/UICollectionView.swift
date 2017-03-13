//
//  UICollectionView.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/9/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  func scrollToTop() {
    if self.numberOfItems(inSection: 0) == 0 {
      return
    }
    self.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
  }
  
}

