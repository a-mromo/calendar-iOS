//
//  PatientDetailVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 10/2/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class PatientDetailVC: UIViewController {
  
  var testArray = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item"]
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
  }
  
}

extension PatientDetailVC: UITableViewDataSource, UITableViewDelegate {
  
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


/*
 


class PatientDetailVC: UIViewController {
  var patient: Patient?
  var appointmentsForPatient: [Appointment]?
  let persistentContainer = CoreDataStore.instance.persistentContainer
  private let segueEditPatient = "SegueEditPatient"
  
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
    }
  }
  
  
  

}

extension PatientDetailVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        
      }
    } else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "PatientAppointmentCell", for: indexPath) as! PatientAppointmentCell
      if let appointments = appointmentsForPatient {
        let appointment = appointments[indexPath.row]
        
        cell.dateLabel.text = shortDateFormatter( date: appointment.date)
        if let note = appointment.note {
          cell.noteLabel.text = note
        } else {
          cell.noteLabel.text = "There isn't any note for appointment with \(appointment.patient.fullName)"
        }
      }
      return cell
    }
    return cell
  }
  
 }
 */
