//
//  CustomSearchBar.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 7/15/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

extension UISearchBar {
  
  var textColor:UIColor? {
    get {
      if let textField = self.value(forKey: "searchField") as?
        UITextField  {
        return textField.textColor
      } else {
        return nil
      }
    }
    
    set (newValue) {
      if let textField = self.value(forKey: "searchField") as?
        UITextField  {
        textField.textColor = newValue
      }
    }
  }
  
  func didPresentSearchController(searchController: UISearchController) {
    searchController.searchBar.showsCancelButton = false
  }
}
