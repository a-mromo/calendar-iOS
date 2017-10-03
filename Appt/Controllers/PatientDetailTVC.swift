//
//  PatientDetailTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/21/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class PatientDetailTVC: UITableViewController {
  
  var patient: Patient?
  var appointmentsForPatient: [Appointment]?
  let persistentContainer = CoreDataStore.instance.persistentContainer
  private let segueEditPatient = "SegueEditPatient"
  private let segueAppts = "AppointmentForPatient"
  
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
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var mobilePhoneLabel: UILabel!
  @IBOutlet weak var homePhoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  @IBAction func editPatient(_ sender: UIButton) {
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    noLargeTitles()
    checkAppointments()
    
    }
  
  override func viewWillAppear(_ animated: Bool) {
    setupUI()
  }
  
  
  
  func noLargeTitles(){
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
      tableView.dragDelegate = self as? UITableViewDragDelegate
    }
  }
  
  func setupUI() {
    guard let patient = patient else { return }
    nameLabel.text = patient.fullName
    
    if patient.mobilePhone != nil {
      mobilePhoneLabel.text = patient.mobilePhone
    }
    if patient.homePhone != nil {
      homePhoneLabel.text = patient.homePhone
    }
    if patient.email != nil {
      emailLabel.text = patient.email
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueEditPatient {
      if let destinationNavigationViewController = segue.destination as? UINavigationController {
        // Configure View Controller
        let targetController = destinationNavigationViewController.topViewController as! NewPatientTableVC
        targetController.patient = patient
      }
    } else if segue.identifier == segueAppts {
      if let destinationNavigationVC = segue.destination as? ApptsForPatientContainerView {
        if let selectedPatient = patient {
          destinationNavigationVC.patient = selectedPatient
        }
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 { return 272 }
    case 1:
      switch indexPath.row {
      case 0:
        if appointmentsForPatient?.count != 0 { return 200 }
        else { return 0.0 }
      case 1:
        return 80
      case 2:
        return 80
      default:
        return UITableViewAutomaticDimension
      }
    default:
      return UITableViewAutomaticDimension
    }
    return UITableViewAutomaticDimension
    
  }
  
  
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = UITableViewCell()
//    if indexPath.section == 0 {
//      if indexPath.row == 0 {
//
//      }
//    } else if indexPath.section == 1 {
//      let cell = tableView.dequeueReusableCell(withIdentifier: "PatientAppointmentCell", for: indexPath) as! PatientAppointmentCell
//      if let appointments = appointmentsForPatient {
//        let appointment = appointments[indexPath.row]
//
//        cell.dateLabel.text = shortDateFormatter( date: appointment.date)
//        if let note = appointment.note {
//          cell.noteLabel.text = note
//        } else {
//          cell.noteLabel.text = "There isn't any note for appointment with \(appointment.patient.fullName)"
//        }
//      }
//      return cell
//    }
//    return cell
//  }
  
  
}


extension PatientDetailTVC {
  
  func checkAppointments() {
    fetchAppointmentsForPatient()
    
    if let fetchedAppointments = fetchedResultsController.fetchedObjects {
      appointmentsForPatient = fetchedAppointments
//      print(appointmentsForPatient)
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

extension PatientDetailTVC: NSFetchedResultsControllerDelegate {
  
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

