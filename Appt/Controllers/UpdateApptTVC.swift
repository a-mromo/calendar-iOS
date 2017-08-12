//
//  UpdateApptTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/6/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar

class UpdateApptTVC: UITableViewController, AppointmentTVC {
  
  var selectedTimeSlot: Date?
  
  var patient: Patient? {
    didSet {
      if patient?.fullName != nil {
        patientLabel.text = patient?.fullName
      }
    }
  }
  
  var appointment: Appointment?
  let formatter = DateFormatter()
  var appointmentLoaded: Bool! 
  
  let segueSelectPatient = "SegueSelectPatientsTVC"
  
  let persistentContainer = CoreDataStore.instance.persistentContainer
  var managedObjectContext: NSManagedObjectContext?
  
  var datePickerHidden = false
  var calendarViewHidden = false
  
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
//  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func confirmAppointment(_ sender: UIBarButtonItem) {
    confirmAppointment()
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    noLargeTitles()
    setupCalendarView()
    setupKeyboardNotification()
    setTextFieldDelegates()
    setTextViewDelegates()
    setDoneOnKeyboard()
    
    calendarView.visibleDates{ (visibleDates) in
      self.setupViewsFromCalendar(from: visibleDates)
    }
    
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if appointmentLoaded {
      loadAppointment()
      appointmentLoaded = false
    }
    
  }
  
  func loadAppointment() {
    if let appointment = appointment {
      if let date = appointment.date,
        let patient = appointment.patient,
        let cost = appointment.cost,
        let note = appointment.note {
        
        let dates: [Date] = [date]
        calendarView.scrollToDate(date, animateScroll: false)
        calendarView.selectDates( dates )
        //        calendarView.date
        //        dateDetailLabel.text = dateFormatter(date: date)
        patientLabel.text = patient.fullName
        self.patient = patient
        costTextField.text = cost
        noteTextView.text = note
        //        datePicker.date = date
        
        print("Appointment date: \(String(describing: dates.first))")
        //        print("CalendarView date: \(calendarView.selectDates)")
      }
    }
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
  
  func confirmAppointment() {
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
  
  
  func noLargeTitles(){
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
      tableView.dragDelegate = self as? UITableViewDragDelegate
    }
  }
  
  func setupKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(NewApptTableViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(NewApptTableViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
      tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + 20, 0)
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    UIView.animate(withDuration: 0.2, animations: {
      // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
      self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    })
  }
  
  
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 1
    } else {
      return 22
    }
  }
}


extension UpdateApptTVC {
  func toggleCalendarView() {
    calendarViewHidden = !calendarViewHidden
    
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  func updateDateDetailLabel(date: Date){
    formatter.dateFormat = "MMMM dd, yyyy"
    dateDetailLabel.text = formatter.string(from: date)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      toggleCalendarView()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if calendarViewHidden && indexPath.section == 0 && indexPath.row == 1 {
      return 0
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
}


// Date picker
extension UpdateApptTVC {
  @IBAction func datePickerValue(_ sender: UIDatePicker) {
    datePickerChanged()
  }
  
  // Run datePickerChanged() in viewDidLoad() to display selected date in Label
  func datePickerChanged() {
    //    dateDetailLabel.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
  }
  
  func toggleDatePicker() {
    datePickerHidden = !datePickerHidden
    
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  // Toggle DatePicker
  
  //  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  //    if indexPath.section == 0 && indexPath.row == 0 {
  //      toggleDatePicker()
  //    }
  //  }
  //
  //  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    // Use the datePicker row. The one below is from a previous iteration
  //    if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
  //      return 0
  //    } else {
  //      return super.tableView(tableView, heightForRowAt: indexPath)
  //    }
  //  }
}


extension UpdateApptTVC {
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
  
  func setupCalendarView() {
    // Setup Calendar Spacing
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    
    // Setup Labels
    calendarView.visibleDates{ (visibleDates) in
      self.setupViewsFromCalendar(from: visibleDates)
    }
  }
  
  func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
    guard let date = visibleDates.monthDates.first?.date else { return }
    
    formatter.dateFormat = "yyyy"
    yearLabel.text = formatter.string(from: date)
    
    formatter.dateFormat = "MMMM"
    monthLabel.text = formatter.string(from: date)
  }
  
  //  func calendarViewDateChanged() {
  //    guard let calendarDate = calendarView.selectedDates.first else { return }
  //    dateDetailLabel.text = DateFormatter.localizedString(from: calendarDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
  //  }
}


extension UpdateApptTVC: JTAppleCalendarViewDataSource {
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


extension UpdateApptTVC: JTAppleCalendarViewDelegate {
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
    
    updateDateDetailLabel(date: date)
    //    calendarViewDateChanged()
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    setupViewsFromCalendar(from: visibleDates)
  }
  
}
