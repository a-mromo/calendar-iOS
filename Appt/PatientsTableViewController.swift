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
  
  var managedObjectContext: NSManagedObjectContext?
  
  private let segueAddPatient = "SegueAddPatientTVC"
  
  let persistentContainer = CoreDataStore.instance.persistentContainer
  
  lazy var fetchedResultsController: NSFetchedResultsController<Patient> = {
    let fetchRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Patients"
    
    do {
      try self.fetchedResultsController.performFetch()
      print("Patient Fetch Successful")
    } catch {
      let fetchError = error as NSError
      print("Unable to Perform Fetch Request")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    
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
  
  @objc func applicationDidEnterBackground(_ notification: Notification) {
    save()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedPatient = fetchedResultsController.object(at: indexPath)
    performSegue(withIdentifier: "patientSelected", sender: self)
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let patient = fetchedResultsController.object(at: indexPath)
      persistentContainer.viewContext.delete(patient)
      save()
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueAddPatient {
      if let destinationNavigationViewController = segue.destination as? UINavigationController {
        let targetController = destinationNavigationViewController.topViewController as! NewPatientTableVC
        targetController.managedObjectContext = persistentContainer.viewContext
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
