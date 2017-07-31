//
//  NewApptTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/17/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar

class NewApptTableViewController: UITableViewController {
  
  
  var patient: Patient?
  let formatter = DateFormatter()
  
  let segueSelectPatient = "SegueSelectPatientsTVC"
  
  let persistentContainer = CoreDataStore.instance.persistentContainer
  var managedObjectContext: NSManagedObjectContext?
  
  var datePickerHidden = false
  
  // Calendar Color
  let outsideMonthColor = UIColor(hexCode: "#584a66")!
  let monthColor = UIColor.white
  let selectedMonthColor = UIColor(hexCode: "#3a294b")!
  let currentDateSelectedViewColor = UIColor(hexCode: "#4e3f5d")!
  
  
  @IBOutlet var calendarView: JTAppleCalendarView!
  @IBOutlet var monthLabel: UILabel!
  @IBOutlet var yearLabel: UILabel!
  
  @IBOutlet weak var patientLabel: UILabel!
  @IBOutlet weak var noteTextView: UITextView!

  @IBOutlet weak var costTextField: UITextField!
  
  @IBOutlet weak var dateDetailLabel: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func confirmAppointment(_ sender: UIBarButtonItem) {
    
    let appointment = Appointment(context: persistentContainer.viewContext)
    
    appointment.patient = patient
//    appointment.date = datePicker.date
    appointment.date = calendarView.selectedDates.first
    appointment.note = noteTextView.text
    appointment.cost = costTextField.text
    appointment.dateCreated = Date()
    
    do {
      try persistentContainer.viewContext.save()
      print("Appointment Saved")
    } catch {
      print("Unable to Save Changes")
      print("\(error), \(error.localizedDescription)")
    }
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCalendarView()
    datePickerChanged()
    noLargeTitles()
    setTextFieldDelegates()
    setTextViewDelegates()
    setDoneOnKeyboard()
    noteTextView.placeholder = "Notes"
    
  }
  
  func setupCalendarView() {
    // Setup Calendar Spacing
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    
    // Setup Labels
    calendarView.visibleDates{ (visibleDates) in
      self.setupViewsFromCalendar(from: visibleDates)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if patient != nil {
      patientLabel.text = patient?.fullName
    }
  }
  
  
  func noLargeTitles(){
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
      tableView.dragDelegate = self as? UITableViewDragDelegate
    }
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
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
  
}

extension NewApptTableViewController {
  func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
    guard let validCell = view as? CustomCell else { return }
    if validCell.isSelected {
      validCell.selectedView.isHidden = false
    } else {
      validCell.selectedView.isHidden = true
    }
  }
  
  func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
    guard let validCell = view as? CustomCell else {
      return
    }
    
    if validCell.isSelected {
      validCell.dateLabel.textColor = selectedMonthColor
    } else {
      if cellState.dateBelongsTo == .thisMonth {
        validCell.dateLabel.textColor = monthColor
      } else {
        validCell.dateLabel.textColor = outsideMonthColor
      }
      
    }
  }
  
  
  func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
    guard let date = visibleDates.monthDates.first?.date else { return }
    
    self.formatter.dateFormat = "yyyy"
    self.yearLabel.text = self.formatter.string(from: date)
    
    self.formatter.dateFormat = "MMMM"
    self.monthLabel.text = self.formatter.string(from: date)
  }
}


extension NewApptTableViewController: JTAppleCalendarViewDataSource {
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    formatter.dateFormat = "yyyy MM dd"
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Calendar.current.locale
   
    var parameters: ConfigurationParameters
    var startDate = Date()
    var endDate = Date()
    if let calendarStartDate = formatter.date(from: "2017 01 01"),
      let calendarEndndDate = formatter.date(from: "2017 12 31") {
      startDate = calendarStartDate
      endDate = calendarEndndDate
    }
    parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
    
    return parameters
  }
}


extension NewApptTableViewController: JTAppleCalendarViewDelegate {
  // Display Cell
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
    cell.dateLabel.text = cellState.text
    
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
    
    return cell
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
    
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    setupViewsFromCalendar(from: visibleDates)
  }
  
}








