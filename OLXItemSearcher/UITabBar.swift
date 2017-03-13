//
//  UITabBar.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/11/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit

extension UITabBar {
  
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    super.sizeThatFits(size)
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = Config.TabBarStyle.height
    return sizeThatFits
  }
  
}
