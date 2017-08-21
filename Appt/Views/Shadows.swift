//
//  Shadows.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/20/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

extension UIView {
  
  func dropShadow() {
    
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.2
    self.layer.shadowOffset = CGSize(width: 0, height: 4)
    self.layer.shadowRadius = 4
    
    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale =  UIScreen.main.scale
  }
  
}


extension UICollectionView {
  
  func dropShadowDown() {
    
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 6)
    self.layer.shadowOpacity = 0.2
    self.layer.shadowRadius = 4
    self.clipsToBounds = false
    self.layer.masksToBounds = false
  }
}
