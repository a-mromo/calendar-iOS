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
    
    if searchController.isActive && searchController.searchBar.text != "" {
      self.selectedPatient = filteredPatient[indexPath.row]
      performSegue(withIdentifier: "patientSelected", sender: self)
    } else {
      self.selectedPatient = fetchedResultsController.object(at: indexPath)
      performSegue(withIdentifier: "patientSelected", sender: self)
    }
    
  }
  
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
  
  /*
  
  func createSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    
    let placeholderAttributes: [NSAttributedStringKey : AnyObject] = [
      NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):
        UIFont.systemFont(ofSize: UIFont.systemFontSize)
    ]
    
    let buttonAttributes: [NSAttributedStringKey : AnyObject] = [
      NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):
        UIColor(hexCode: "#11A9FB")!,
      NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):
        UIFont.systemFont(ofSize: UIFont.buttonFontSize)
    ]
    
    let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search Patient", attributes: placeholderAttributes)
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
    
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Delete"
    UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(buttonAttributes, for: .normal)
    
    UISearchBar.appearance().backgroundColor = UIColor(hexCode: "#FFFFFF")!
    
    let searchBarCursor = searchController.searchBar.subviews[0]
    searchBarCursor.tintColor = UIColor(hexCode: "#00EAF8")!

//    navigationController?.navigationBar.barStyle = .blackOpaque
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.searchController = searchController
    }
    else {
      tableView.tableHeaderView = searchController.searchBar
    }
    
//    let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
//    textFieldInsideSearchBar?.textColor = UIColor.purple
//
//    let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
//    imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//    imageV.tintColor = UIColor.purple
  }
 
 */
  
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
