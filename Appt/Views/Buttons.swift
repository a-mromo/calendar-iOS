//
//  Buttons.swift
//
//
//  Created by Agustin Mendoza Romo on 9/24/17.
//

import UIKit

class WireButton: UIButton {
  
  var mainUIColor = UIColor(hexCode: "#B75AFE")!
  
  override func draw(_ rect: CGRect) {
    self.layer.cornerRadius = 8
    self.setTitleColor(mainUIColor, for: .normal)
    self.layer.borderWidth = 1
    self.layer.borderColor = mainUIColor.cgColor
    self.contentEdgeInsets = UIEdgeInsetsMake(10,40,10,40)
    
  }
  
}


