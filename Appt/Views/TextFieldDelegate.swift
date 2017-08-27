//
//  TextFieldDelegate.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 7/18/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

extension NewApptTableViewController: UITextFieldDelegate {
  
  func setTextFieldDelegates(){
    self.costTextField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}


extension UpdateApptTVC: UITextFieldDelegate {
  func setTextFieldDelegates(){
    self.costTextField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}


extension NewPatientTableVC: UITextFieldDelegate {
  
  func setTextFieldDelegates(){
    self.lastNameTextField.delegate = self
    self.nameTextField.delegate = self
    self.homePhoneTextField.delegate = self
    self.mobilePhoneTextField.delegate = self
    self.patientEmailTextField.delegate = self
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}


