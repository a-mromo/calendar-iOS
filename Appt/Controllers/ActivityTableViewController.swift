//
//  ActivityTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/1/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class ActivityTableViewController: UITableViewController {
  
  let persistentContainer = CoreDataStore.instance.persistentContainer
  
  lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
    let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  // MARK: - Table view data source
  
  override func viewDidLoad() {
    performFetch()
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
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let appointments = fetchedResultsController.fetchedObjects else { return 0 }
    return appointments.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 96
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
    
    let appointment = fetchedResultsController.object(at: indexPath)
    //      cell.timeIntervalLabel.text = dateFormatter(date: appointment.date)
    let timeAgo:String = timeAgoSinceDate(appointment.dateCreated, currentDate: Date(), numericDates: true)
    
    cell.timeIntervalLabel.text = timeAgo
    cell.activityLabel.text = "New appointment with \(String(describing: appointment.patient.fullName)) for \(dateFormatter(date: appointment.date)) at \(hourFormatter(date: appointment.date))"
    
    return cell
  }
  
}

extension ActivityTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      print("Patient Created")
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
      break;
    case .delete:
      print("Patient Deleted")
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .update:
      if let indexPath = indexPath {
        print("Patient Updated")
        tableView.reloadRows(at: [indexPath], with: .fade)
      }
      break;
    default:
      print("...")
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
  }
}


