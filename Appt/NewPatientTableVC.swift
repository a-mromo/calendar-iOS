//
//  NewPatientTableVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/23/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class NewPatientTableVC: UITableViewController {
  
  let persistentContainer = CoreDataStore.instance.persistentContainer
  
  var patient: Patient?
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var mobilePhoneTextField: UITextField!
  @IBOutlet weak var homePhoneTextField: UITextField!
  @IBOutlet weak var patientEmailTextField: UITextField!
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
    
  }
  @IBAction func saveButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
    savePatient()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if patient != nil {
      loadPatient()
    }
  }
  
  func savePatient() {
    if self.patient == nil {
      let patient = Patient(context:persistentContainer.viewContext)
      
      patient.name = nameTextField.text
      patient.lastName = lastNameTextField.text
      patient.mobilePhone = mobilePhoneTextField.text
      patient.homePhone = homePhoneTextField.text
      patient.email = patientEmailTextField.text
      
      save()
    } else {
      updatePatient()
    }
  }
  
  func loadPatient() {
    guard let patient = patient else { return }
    nameTextField.text = patient.name
    lastNameTextField.text = patient.lastName
    mobilePhoneTextField.text = patient.mobilePhone
    homePhoneTextField.text = patient.homePhone
    patientEmailTextField.text = patient.email
  }
  
  func save() {
    do {
      try persistentContainer.viewContext.save()
    } catch {
      print("Unable to Save Changes")
      print("\(error), \(error.localizedDescription)")
    }
  }
  
  func updatePatient() {
    guard let patient = patient else { return }
    
    patient.name = nameTextField.text
    patient.lastName = lastNameTextField.text
    patient.mobilePhone = mobilePhoneTextField.text
    patient.homePhone = homePhoneTextField.text
    patient.email = patientEmailTextField.text
    
    save()
  }
  
  // Needs impementing textFieldDidChanged
  func patientFromTextFields() {
    guard let patient = patient else { return }
    
    patient.name = nameTextField.text
    patient.lastName = lastNameTextField.text
    patient.mobilePhone = mobilePhoneTextField.text
    patient.homePhone = homePhoneTextField.text
    patient.email = patientEmailTextField.text
  }
  
  
  
}
