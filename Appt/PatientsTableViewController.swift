//
//  PatientsTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/22/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class PatientsTableViewController: UITableViewController {
  
  var selectedPatient: Patient?
  
  private let segueAddPatient = "SegueAddPatientTVC"
  
  private let persistentContainer = NSPersistentContainer(name: "AppointmentModel")
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Patient> = {
    // Create Fetch Request
    let fetchRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
    
    // Configure Fetch Request
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
    
    // Create Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    // Configure Fetched Results Controller
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
 
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Patients"
    
    persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
      if let error = error {
        print("Unable to Load Persistent Store")
        print("\(error), \(error.localizedDescription)")
        
      } else {
        do {
          try self.fetchedResultsController.performFetch()
          print("Patient Fetch Successful")
        } catch {
          let fetchError = error as NSError
          print("Unable to Perform Fetch Request")
          print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
      }
    }
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)

  }
  
  override func viewWillAppear(_ animated: Bool) {
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let patients = fetchedResultsController.fetchedObjects else { return 0 }
    return patients.count
  }
  
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientCell
    let patient = fetchedResultsController.object(at: indexPath)
    cell.patientNameLabel.text = patient.fullName
    return cell
    
   }
  
  func save() {
    do {
      try persistentContainer.viewContext.save()
    } catch {
      print("Unable to Save Changes")
      print("\(error), \(error.localizedDescription)")
    }
  }
  
  func applicationDidEnterBackground(_ notification: Notification) {
    save()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedPatient = fetchedResultsController.object(at: indexPath)
   performSegue(withIdentifier: "patientSelected", sender: self)
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Fetch Quote
      let quote = fetchedResultsController.object(at: indexPath)
      
      // Delete Quote
      quote.managedObjectContext?.delete(quote)
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueAddPatient {
      if let destinationNavigationViewController = segue.destination as? UINavigationController {
        // Configure View Controller
        let targetController = destinationNavigationViewController.topViewController as! NewPatientTableVC
        targetController.managedObjectContext = persistentContainer.viewContext
        print("context sent")
      }
    }
  }

  
  
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
}


extension PatientsTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  // Update View
  
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
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
