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
    UIApplication.shared.statusBarStyle = .lightContent
    UINavigationBar.appearance().barTintColor = UIColor(hexCode: "#11A9FB")!
    UINavigationBar.appearance().tintColor = UIColor(hexCode: "#ffffff")!
    UIApplication.shared.statusBarStyle = .lightContent
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor(hexCode: "#ffffff")!]
    UITabBar.appearance().tintColor = UIColor(hexCode: "#794DFF")!

    largeTitles()
    
    
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

