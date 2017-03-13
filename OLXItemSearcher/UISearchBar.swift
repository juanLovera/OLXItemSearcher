//
//  UISearchBar.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/12/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit

extension UISearchBar {
  
  private func getViewElement<T>(type: T.Type) -> T? {
    let svs = subviews.flatMap { $0.subviews }
    guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
    return element
  }
  
  func getSearchBarTextField() -> UITextField? {
    return getViewElement(type: UITextField.self)
  }
  
  func setTextColor(color: UIColor) {
    if let textField = getSearchBarTextField() {
      textField.textColor = color
    }
  }
  
  func setTextFieldColor(color: UIColor) {
    if let textField = getViewElement(type: UITextField.self) {
      switch searchBarStyle {
      case .minimal:
        textField.layer.backgroundColor = color.cgColor
        textField.layer.cornerRadius = 6
        
      case .prominent, .default:
        textField.backgroundColor = color
      }
    }
  }
  
  func setPlaceholderTextColor(color: UIColor) {
    if let textField = getSearchBarTextField() {
      textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName: color])
    }
  }
  
  func setSearchImageColor(color: UIColor) {
    let searchBar = getSearchBarTextField()
    if let imageView = searchBar?.leftView as? UIImageView {
      imageView.image = imageView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
      imageView.tintColor = color
    }
  }
  
  func setBackgroundColor(color : UIColor) {
    for subView in self.subviews {
      for subSubView in subView.subviews {
        if let _ = subSubView as? UITextInputTraits {
          let textField = subSubView as! UITextField
          textField.backgroundColor = color
          break
        }
      }
    }
  }
  
}
