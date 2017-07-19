//
//  TextViewDelegate.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 7/18/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

extension NewApptTableViewController:  UITextViewDelegate {
  
  func setTextViewDelegates(){
    self.noteTextView.delegate = self
  }
  
  func textViewShouldReturn(_ textField: UITextView) -> Bool {
    self.view.endEditing(true)
    return false
  }
}

