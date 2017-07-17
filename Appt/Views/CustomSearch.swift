//
//  CustomSearch.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 7/16/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

extension UISearchBar {
  public func setSerchTextcolor(color: UIColor) {
    let clrChange = subviews.flatMap { $0.subviews }
    guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
    sc.textColor = color
  }
}

extension PatientsTableViewController {
  
  func createSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    
    let searchBarCursor = searchController.searchBar.subviews[0]
    searchBarCursor.tintColor = UIColor(hexCode: "#00EAF8")!
    
    //    navigationController?.navigationBar.barStyle = .blackOpaque
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.searchController = searchController
    }
    else {
      tableView.tableHeaderView = searchController.searchBar
    }
    
    //    let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
    //    textFieldInsideSearchBar?.textColor = UIColor.purple
    //
    //    let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
    //    imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    //    imageV.tintColor = UIColor.purple
  }
}
