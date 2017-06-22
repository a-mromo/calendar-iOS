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
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var mobilePhoneLabel: UILabel!
  @IBOutlet weak var homePhoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  override func viewDidLoad() {
        super.viewDidLoad()
      setupUI()
    
    }
  
  func setupUI() {
    guard let patient = patient else {
      print("Couldn't access patient")
      return
    }
    nameLabel.text = patient.fullName
    mobilePhoneLabel.text = patient.mobilePhone
    homePhoneLabel.text = patient.homePhone
    emailLabel.text = patient.email
    
    
//    if let patientName = patient?.fullName {
//      nameLabel.text = patientName
//    } else {
//      print("Couldn't access name")
//    }
  }
  
}
