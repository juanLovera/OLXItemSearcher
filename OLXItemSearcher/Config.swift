//
//  Config.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/5/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit

struct Config {
  
  struct ServicesURLs {
    static let base = "http://api-v2.olx.com";
    static let publicFetchItems = "\(base)/items"
  }
  
  struct ItemsFetch {
    static let pageSizeForFetching = 20
    static let defaultLocationForAllSearchs = "www.olx.com.ar"
  }
  
  struct CollectionViews {
    static let defaultCellSize = CGSize(width: 165, height: 260)
    static let cellsPerLineInPortrait = 2
    static let cellsPerLineInLandscape = 4
  }
  
  struct SearchBarStyle {
    static let background = UIColor(red:0.21, green:0.47, blue:0.84, alpha:1.0)
  }
  
  struct TabBarStyle {
    static let height: CGFloat = 40
  }
  
}
