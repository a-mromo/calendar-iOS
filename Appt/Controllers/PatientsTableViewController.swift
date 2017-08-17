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
  var filteredPatient = [Patient]()
  
  let searchController = UISearchController(searchResultsController: nil)
  
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
    
    fetchPatients()
    createSearchBar()
    title = "Patients"
    
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if searchController.isActive && searchController.searchBar.text != "" {
      return filteredPatient.count
    }
    
    guard let patients = fetchedResultsController.fetchedObjects else { return 0 }
    return patients.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientCell
    
    if searchController.isActive && searchController.searchBar.text != "" {
      let patient = filteredPatient[indexPath.row]
      cell.patientNameLabel.text = patient.fullName
    } else {
      let patient = fetchedResultsController.object(at: indexPath)
      cell.patientNameLabel.text = patient.fullName
      return cell
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
//    guard let destinationVC = self.navigationController?.viewControllers[0] as?  NewApptTableViewController
//      else {
//        print("Could not instantiate view controller with identifier PatientDetailTVC")
//        return
//    }
    
    if let destinationVC = self.navigationController?.viewControllers[0] as?  NewApptTableViewController {
      if searchController.isActive && searchController.searchBar.text != "" {
        destinationVC.patient = filteredPatient[indexPath.row]
      } else {
        destinationVC.patient = fetchedResultsController.object(at: indexPath)
      }
      self.navigationController?.popViewController(animated: true)
    } else if let destinationVC = self.navigationController?.viewControllers[0] as?  UpdateApptTVC {
      if searchController.isActive && searchController.searchBar.text != "" {
        destinationVC.patient = filteredPatient[indexPath.row]
      } else {
        destinationVC.patient = fetchedResultsController.object(at: indexPath)
      }
      self.navigationController?.popViewController(animated: true)
    }
  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "patientSelected" {
//      if let destinationVC = segue.destination as? NewApptTableViewController {
//        destinationVC.patient = self.selectedPatient
//      }
//    }
//  }
  
  func fetchPatients() {
    do {
      try self.fetchedResultsController.performFetch()
      print("Patient Fetch Successful")
    } catch {
      let fetchError = error as NSError
      print("Unable to Perform Fetch Request")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
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
  
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let patient = fetchedResultsController.object(at: indexPath)
      persistentContainer.viewContext.delete(patient)
      save()
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
      print("Patient Created")
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
      break;
    case .delete:
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


extension PatientsTableViewController: UISearchControllerDelegate, UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    if let searchText = searchController.searchBar.text {
      print(searchText)
      let predicate = NSPredicate(format: "name CONTAINS %@", searchText)
      if let fetchedObjects = fetchedResultsController.fetchedObjects {
        filteredPatient = fetchedObjects.filter({return predicate.evaluate(with: $0)})
      }
    }
    tableView.reloadData()
  }
  
  func didDismissSearchController(_ searchController: UISearchController) {
//    filteredPatient = nil
    filteredPatient.removeAll()
    tableView.reloadData()
  }
}