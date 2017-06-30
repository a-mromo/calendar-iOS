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
  
  var managedObjectContext: NSManagedObjectContext?
  
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
      guard let managedObjectContext = managedObjectContext else { return }
      
      let patient = Patient(context: managedObjectContext)
      
      patient.name = nameTextField.text
      patient.lastName = lastNameTextField.text
      patient.mobilePhone = mobilePhoneTextField.text
      patient.homePhone = homePhoneTextField.text
      patient.email = patientEmailTextField.text
      
      createPatient()
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
  
  func createPatient() {
    guard let managedObjectContext = managedObjectContext else { return }
    
    do {
      try managedObjectContext.save()
      print("Patient Created")
    } catch {
      print("Unable to Save Changes")
      print("\(error), \(error.localizedDescription)")
    }
  }
  
  func updatePatient() {
    patientFromTextFields()
    do {
      try persistentContainer.viewContext.save()
      print("Patient Updated")
    } catch {
      print("Unable to Save Changes")
      print("\(error), \(error.localizedDescription)")
    }
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
