//
//  UpdateApptTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/27/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

let persistentContainer = CoreDataStore.instance.persistentContainer

class UpdateApptTVC: NewApptTableViewController {
  
  var appointment: Appointment?
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    datePickerChanged()
    loadAppointment()
  }
  
  func loadAppointment() {
    if let appointment = appointment {
      if let date = appointment.date,
        let patient = appointment.patient,
        let cost = appointment.cost,
        let note = appointment.note {
        
        dateDetailLabel.text = dateFormatter(date: date)
        patientLabel.text = patient.fullName
        costTextField.text = cost
        notesTextField.text = note
        datePicker.date = date
      }
    }
  }
  
  override func confirmAppointment(_ sender: UIBarButtonItem) {
    
    guard let appointment = appointment else {
      return
    }
    appointment.patient = patient
    appointment.date = datePicker.date
    appointment.note = notesTextField.text
    appointment.cost = costTextField.text
    appointment.dateModified = Date()
    
    updateAppt()
    dismiss(animated: true, completion: nil)
  }
  
  func updateAppt() {
    do {
      try persistentContainer.viewContext.save()
      print("Appointment Saved")
    } catch {
      print("Unable to Save Changes")
      print("\(error), \(error.localizedDescription)")
    }
  }
  
}
