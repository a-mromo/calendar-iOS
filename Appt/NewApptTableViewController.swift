//
//  NewApptTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/17/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class NewApptTableViewController: UITableViewController {

//  var appointment = Appointment()
  var patient: Patient?
  
  var managedObjectContext: NSManagedObjectContext?
  
  var datePickerHidden = false
  
  @IBOutlet weak var patientLabel: UILabel!
  @IBOutlet weak var notesTextField: UITextField!
  @IBOutlet weak var costTextField: UITextField!
  
  @IBOutlet weak var dateDetailLabel: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  func createAppointmentObject() {
    guard let managedObjectContext = managedObjectContext else { return }
    
    let appointment = Appointment(context: managedObjectContext)
    
   appointment.patient = patient
    appointment.date = datePicker.date /* as NSDate */
    appointment.note = notesTextField.text
    if let cost = Int16(costTextField.text!) {
      appointment.cost = cost
    }
    
  }
  
  @IBAction func confirmAppointment(_ sender: UIBarButtonItem) {
    
    guard let managedObjectContext = managedObjectContext else {
      return }

    
    let appointment = Appointment(context: managedObjectContext)
    
    appointment.patient = patient
    appointment.date = datePicker.date /* as NSDate */
    appointment.note = notesTextField.text
    if let cost = Int16(costTextField.text!) {
      appointment.cost = cost
    }
    
    
    dismiss(animated: true, completion: nil)
  }
    override func viewDidLoad() {
        super.viewDidLoad()

      datePickerChanged()
    }

  @IBAction func datePickerValue(_ sender: UIDatePicker) {
    datePickerChanged()
  }
  
  func datePickerChanged() {
    dateDetailLabel.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
  }
  
  func toggleDatePicker() {
    datePickerHidden = !datePickerHidden
    
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      toggleDatePicker()
    }
    if indexPath.section == 1 && indexPath.row == 0 {
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
      return 0
    } else{
      return super.tableView(tableView, heightForRowAt: indexPath)
    }

  }
  
  
  @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
    if sender.identifier == "patientSelected" {
      let patientsVC = sender.source as! PatientsTableViewController
      print("UnwindToThisView()")
      self.patient = patientsVC.selectedPatient
      patientLabel.text = self.patient?.fullName
    }
  }
  
}
