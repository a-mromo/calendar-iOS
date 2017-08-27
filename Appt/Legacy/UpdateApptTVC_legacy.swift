//
//  UpdateApptTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/27/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

// This class avoided duplicating code from the NewApptTableViewController class, to create
// the UpdateApptTVC.
// Was unable to implement the JTLAppleCalendar in this view by inherinting from another class.
// Decided to duplicate the code from NewApptTableViewController and update it with the changes from
// this file.
// Renamed this file and clas with the "_legacy"


import UIKit
import CoreData

class UpdateApptTVC_legacy: NewApptTableViewController {
  
  var appointment: Appointment?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      noLargeTitles()
//      setupCalendarView()
      setupKeyboardNotification()
      
      calendarView.visibleDates{ (visibleDates) in
        self.setupViewsFromCalendar(from: visibleDates)
      }
    }
  
  override func viewWillAppear(_ animated: Bool) {
//    datePickerChanged()
    loadAppointment()
  }

  
  func loadAppointment() {
    guard let appointment = self.appointment else { return }
    calendarView.scrollToDate(appointment.date, animateScroll: false)
    calendarView.selectDates( [appointment.date] )
    
    self.patient = appointment.patient
    patientLabel.text = appointment.patient.fullName
    
    if let cost = appointment.cost {
      costTextField.text = cost
    }
    if let note = appointment.note {
      noteTextView.text = note
    }
    print("Appointment date: \(String(describing: appointment.date))")
  }
  
  override func confirmAppointment(_ sender: UIBarButtonItem) {
    
    guard let appointment = appointment else { return }
    guard let patient = self.patient else { return }
    guard let selectedTimeSlot = self.selectedTimeSlot else { return }
    appointment.patient = patient
    appointment.date = selectedTimeSlot
    appointment.dateModified = Date()
    
    if noteTextView.text != nil {
      appointment.note = noteTextView.text
    }
    if costTextField.text != nil {
      appointment.cost = costTextField.text
    }
    
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
 

