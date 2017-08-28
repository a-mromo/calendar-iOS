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
    if case emptyRequiredFields() = false {
      dismiss(animated: true)
      savePatient()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    noLargeTitles()
    setTextFieldDelegates()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if patient != nil {
      loadPatient()
    }
  }
  
  func noLargeTitles(){
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
      tableView.dragDelegate = self as? UITableViewDragDelegate
    }
  }
  
  func savePatient() {
    if self.patient == nil {
      let patient = Patient(context:persistentContainer.viewContext)
      patientFromTextFields(patient)
      CoreDataStore.instance.save()
    } else {
      updatePatient()
    }
  }
  
  func loadPatient() {
    guard let patient = self.patient else { return }
    nameTextField.text = patient.name
    lastNameTextField.text = patient.lastName

    if patient.mobilePhone != nil {
      mobilePhoneTextField.text = patient.mobilePhone
    }
    if patient.homePhone != nil {
      homePhoneTextField.text = patient.homePhone
    }
    if patient.email != nil {
      patientEmailTextField.text = patient.email
    }
  }
  
  func updatePatient() {
    guard let patient = self.patient else { return }
    patientFromTextFields(patient)
    CoreDataStore.instance.save()
  }
  
  func patientFromTextFields(_ patient: Patient) {
    patient.name = nameTextField.text!
    patient.lastName = lastNameTextField.text!
    
    if mobilePhoneTextField.text != "" {
      patient.mobilePhone = mobilePhoneTextField.text
    }
    if homePhoneTextField.text != "" {
      patient.homePhone = homePhoneTextField.text
    }
    if patientEmailTextField.text != "" {
      patient.email = patientEmailTextField.text
    }
  }
  
  func emptyRequiredFields() -> Bool {
    if nameTextField.text == "" || lastNameTextField.text == "" {
      userInfoAlert()
      return true
    } else {
      return false
    }
  }
  
  func userInfoAlert() {
    let alert = UIAlertController(title: "Full Name Required", message: "Please fill in the name and last name of the patient", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
      NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
}
