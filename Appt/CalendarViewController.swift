//
//  CalendarViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/15/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  private let segueNewApptTVC = "SegueNewApptTVC"
  
  var appointments = [Appointment]()
  
  private let persistentContainer = CoreDataStore.instance.persistentContainer
  
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
    let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueNewApptTVC {
      if let destinationNavigationViewController = segue.destination as? UINavigationController {
        // Configure View Controller
        let targetController = destinationNavigationViewController.topViewController as! NewApptTableViewController
        targetController.managedObjectContext = persistentContainer.viewContext
         print("context sent")
      }
    }
  }
  
  // MARK: - Notification Handling
  
  func applicationDidEnterBackground(_ notification: Notification) {
    do {
      try persistentContainer.viewContext.save()
      print("Saved Changes")
    } catch {
      print("Unable to Save Changes")
      print("\(error), \(error.localizedDescription)")
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
    default:
      print("...")
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
  }
  
}


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
  
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
    
    cell.nameLabel.text = appointment.patient?.fullName
    if let date = appointment.date {
      cell.dateLabel.text = dateToString(date: date)
    }
    cell.noteLabel.text = appointment.note
    
    return cell
  }
  
  func dateToString (date: Date) -> String{
    
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = .short
    
    let dateString = formatter.string(from: date as Date)
    return dateString
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Fetch Quote
      let quote = fetchedResultsController.object(at: indexPath)
      
      // Delete Quote
      quote.managedObjectContext?.delete(quote)
    }
  }
  
}

