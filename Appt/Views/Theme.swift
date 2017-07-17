//
//  Theme.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 7/10/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
  var errorColor: UIColor { get }
  
  func install()
}


struct DefaultTheme: ThemeProtocol {
  
  var errorColor: UIColor {
    return .red
  }
  
  func install() {
    customNavBar()
    largeTitles()
    customSearchBar()
  }
  
  func customNavBar(){
    UIApplication.shared.statusBarStyle = .lightContent
    UINavigationBar.appearance().barTintColor = UIColor(hexCode: "#11A9FB")!
    UINavigationBar.appearance().tintColor = UIColor(hexCode: "#ffffff")!
    UIApplication.shared.statusBarStyle = .lightContent
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexCode: "#ffffff")!]
    UITabBar.appearance().tintColor = UIColor(hexCode: "#794DFF")!
  }
  
  func customSearchBar() {
    let placeholderAttributes: [NSAttributedStringKey : AnyObject] = [
      NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):
        UIFont.systemFont(ofSize: UIFont.systemFontSize)
    ]
    
    let buttonAttributes: [NSAttributedStringKey : AnyObject] = [
      NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):
        UIColor(hexCode: "#11A9FB")!,
      NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):
        UIFont.systemFont(ofSize: UIFont.buttonFontSize)
    ]
    
    let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search Patient", attributes: placeholderAttributes)
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
    
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Delete"
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(buttonAttributes, for: .normal)
    UISearchBar.appearance().backgroundColor = UIColor(hexCode: "#FFFFFF")!
  }
  
  func largeTitles () {
    if #available(iOS 11.0, *) {
      UINavigationBar.appearance().prefersLargeTitles = true
      UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(hexCode: "#ffffff")!]
    }
  }
}

struct Theme {
  static var current: ThemeProtocol! {
    didSet {
      current.install()
    }
  }
}

