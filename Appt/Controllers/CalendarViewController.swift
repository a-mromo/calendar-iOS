//
//  CalendarViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/12/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var calendarView: JTAppleCalendarView!
  var appointmentsOfTheDay: [Appointment]?
  let formatter = DateFormatter()
  
  private let segueNewApptTVC = "SegueNewApptTVC"
  private let segueApptDetail = "SegueApptDetail"
  
  let persistentContainer = CoreDataStore.instance.persistentContainer
  
  lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
    let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self

    return fetchedResultsController
  }()
  
  // Calendar Color
  let outsideMonthColor = UIColor.lightGray
  let monthColor = UIColor.darkGray
  let selectedMonthColor = UIColor.white
  let currentDateSelectedViewColor = UIColor.black

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    performFetch()
    noLargeTitles()
    setupCalendarView()
    
    calendarView.dropShadowBottom()

    calendarView.scrollToDate(Date(), animateScroll: false)
    calendarView.selectDates( [Date()] )
  }
  
  func performFetch() {
    persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
      
      do {
        try self.fetchedResultsController.performFetch()
        print("Appt Fetch Successful")
      } catch {
        let fetchError = error as NSError
        print("Unable to Perform Fetch Request")
        print("\(fetchError), \(fetchError.localizedDescription)")
      }
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueApptDetail {
      if let indexPath = tableView.indexPathForSelectedRow {
        let appointment = fetchedResultsController.object(at: indexPath)
        let controller = (segue.destination as! ApptDetailTVC)
        controller.appointment = appointment
      }
    }
  }
  
  func applicationDidEnterBackground(_ notification: Notification) {
    CoreDataStore.instance.save()
  }
  
  
  func noLargeTitles(){
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
      tableView.dragDelegate = self as? UITableViewDragDelegate
    }
  }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let appointments = fetchedResultsController.fetchedObjects else { return 0 }
    return appointments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
    
    let appointment = fetchedResultsController.object(at: indexPath)
    cell.nameLabel.text = appointment.patient.fullName
    formatter.dateFormat = "H:mm"
    cell.dateLabel.text = formatter.string(from: appointment.date)
    cell.noteLabel.text = appointment.note
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Fetch Appointment
      let appointment = fetchedResultsController.object(at: indexPath)
      
      // Delete Appointment
      persistentContainer.viewContext.delete(appointment)
      CoreDataStore.instance.save()
    }
  }
  
}



extension CalendarViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
        print("Appt Added")
        tableView.insertRows(at: [indexPath], with: .fade)
      }
      break;
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
      break;
    case .update:
      if let indexPath = indexPath {
        print("Appt Changed and updated")
        tableView.reloadRows(at: [indexPath], with: .fade)
      }
    default:
      print("...")
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
  }
  
}

extension CalendarViewController {
  func loadAppointmentsForDate(date: Date){
    
    let dayPredicate = fullDayPredicate(for: date)
    
    if let fetchedObjects = fetchedResultsController.fetchedObjects {
      appointmentsOfTheDay = fetchedObjects.filter({ return dayPredicate.evaluate(with: $0) })
    }
    
    guard let appointmentsOfTheDay = self.appointmentsOfTheDay else { return }
    // Print Appointments of the Day
    appointmentsOfTheDay.map { print("Appointment date is: \(String(describing: $0.date))") }
    guard let gotoObject = appointmentsOfTheDay.first else { return }
    guard let indexPath = fetchedResultsController.indexPath(forObject: gotoObject) else { return }
  
    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
  
  func fullDayPredicate(for date: Date) -> NSPredicate {
    var calendar = Calendar.current
    calendar.timeZone = NSTimeZone.local
    
    let dateFrom = calendar.startOfDay(for: date)
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateFrom)
    components.day! += 1
    let dateTo = calendar.date(from: components)
    let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [dateFrom, dateTo as Any])
    
    return datePredicate
  }
  
}



extension CalendarViewController {
  func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
    guard let validCell = view as? CalendarDayCell else { return }
    if validCell.isSelected {
      validCell.selectedView.isHidden = false
    } else {
      validCell.selectedView.isHidden = true
    }
  }
  
  func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
    guard let validCell = view as? CalendarDayCell else {
      return
    }
    
    let todaysDate = Date()
    if todaysDate.day() == cellState.date.day() {
      validCell.dateLabel.textColor = UIColor.purple
    } else { 
      validCell.dateLabel.textColor = cellState.isSelected ? UIColor.purple : UIColor.darkGray
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
//    calendarView.visibleDates{ (visibleDates) in
//      self.setupViewsFromCalendar(from: visibleDates)
//    }
  }
  
//  func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
//    guard let date = visibleDates.monthDates.first?.date else { return }
//
//    formatter.dateFormat = "yyyy"
//    yearLabel.text = formatter.string(from: date)
//
//    formatter.dateFormat = "MMMM"
//    monthLabel.text = formatter.string(from: date)
//
//  }
  
  
}



extension CalendarViewController: JTAppleCalendarViewDataSource {
  
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
    parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
    return parameters
  }
  
  
}


extension CalendarViewController: JTAppleCalendarViewDelegate {
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
    cell.dateLabel.text = cellState.text
    
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
    
    return cell
  }
  
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
    
//    updateDateDetailLabel(date: date)
    loadAppointmentsForDate(date: date)
    
    //    calendarViewDateChanged()
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleCellSelected(view: cell, cellState: cellState)
    handleCellTextColor(view: cell, cellState: cellState)
  }
  
//  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//    setupViewsFromCalendar(from: visibleDates)
//  }
  
  
  
}


