//
//  CardView.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 9/22/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class CardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  override func draw(_ rect: CGRect) {
    
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 6)
    self.layer.shadowOpacity = 0.2
    self.layer.shadowRadius = 4
    self.clipsToBounds = false
    self.layer.masksToBounds = false
    self.layer.cornerRadius = 8
    
  }

}
