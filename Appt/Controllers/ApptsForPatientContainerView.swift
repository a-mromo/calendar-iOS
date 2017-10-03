//
//  ApptsForPatientContainerView.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 10/2/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class ApptsForPatientContainerView: UIViewController {
  
  var testArray = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item"]
  var patient: Patient?
  var appointmentsForPatient: [Appointment]?
  let persistentContainer = CoreDataStore.instance.persistentContainer
  
  // Load Appointments for given date
  lazy var fetchedResultsController: NSFetchedResultsController<Appointment> = {
    let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    if let patient = self.patient {
      fetchRequest.predicate = NSPredicate(format: "patient == %@", patient)
    }
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
    if let patientPassed = patient {
      print("Patient was succesfully passed: \(patientPassed.fullName)")
    } else {
      print("ERROR: Couldn't passed patient between views")
    }
    checkAppointments()
  }
  
  
}

extension PatientDetailTVC {
  
  func checkAppointments() {
    fetchAppointmentsForPatient()
    
    if let fetchedAppointments = fetchedResultsController.fetchedObjects {
      appointmentsForPatient = fetchedAppointments
      print("There are \(appointmentsForPatient.count) appointments for: \(patient.fullName)"
    } else {
      print("Patients has no appointments")
    }
  }
  
  func fetchAppointmentsForPatient() {
    do {
      try self.fetchedResultsController.performFetch()
      print("AppointmentForDay Fetch Successful")
    } catch {
      let fetchError = error as NSError
      print("Unable to Perform AppointmentForDay Fetch Request")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
  }
}

extension ApptsForPatientContainerView: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return testArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PatientAppointmentCell", for: indexPath) as! PatientAppointmentCell
    
    cell.noteLabel.text = testArray[indexPath.row]
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 1
    case 1:
      return 1
    default:
      break
    }
    return 1
  }
  
  
}

extension ApptsForPatientContainerView: NSFetchedResultsControllerDelegate {
  
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
      print("Appt Deleted")
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

