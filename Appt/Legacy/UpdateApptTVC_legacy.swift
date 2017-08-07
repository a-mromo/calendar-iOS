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
    if let appointment = appointment {
      if let date = appointment.date,
        let patient = appointment.patient,
        let cost = appointment.cost,
        let note = appointment.note {
        
        let dates: [Date] = [date]
        calendarView.scrollToDate(date)
//        calendarView.date
//        dateDetailLabel.text = dateFormatter(date: date)
        patientLabel.text = patient.fullName
        costTextField.text = cost
        noteTextView.text = note
//        datePicker.date = date
        
        print("Appointment date: \(String(describing: dates.first))")
//        print("CalendarView date: \(calendarView.selectDates)")
      }
    }
  }
  
  override func confirmAppointment(_ sender: UIBarButtonItem) {
    
    guard let appointment = appointment else {
      return
    }
    appointment.patient = patient
//    appointment.date = datePicker.date
    appointment.date = calendarView.selectedDates.first
    appointment.note = noteTextView.text
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
 

