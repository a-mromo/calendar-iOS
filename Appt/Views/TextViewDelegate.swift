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

extension NewApptTableViewController {
  
  func setDoneOnKeyboard() {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NewApptTableViewController.dismissKeyboard))
    keyboardToolbar.items = [flexBarButton, doneBarButton]
    self.noteTextView.inputAccessoryView = keyboardToolbar
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}



// NEEDS REFACTORING -- DUPLICATED CODE -- SEE LEGACY CODE FILE

extension UpdateApptTVC:  UITextViewDelegate {
  
  func setTextViewDelegates(){
    self.noteTextView.delegate = self
  }
  
  func textViewShouldReturn(_ textField: UITextView) -> Bool {
    self.view.endEditing(true)
    return false
  }
}

extension UpdateApptTVC {
  
  func setDoneOnKeyboard() {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NewApptTableViewController.dismissKeyboard))
    keyboardToolbar.items = [flexBarButton, doneBarButton]
    self.noteTextView.inputAccessoryView = keyboardToolbar
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

