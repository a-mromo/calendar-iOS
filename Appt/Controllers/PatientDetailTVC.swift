//
//  PatientDetailTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/21/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class PatientDetailTVC: UITableViewController {
  
  var patient: Patient?
  
  private let segueEditPatient = "SegueEditPatient"
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var mobilePhoneLabel: UILabel!
  @IBOutlet weak var homePhoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  @IBAction func editPatient(_ sender: UIButton) {
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    noLargeTitles()
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
