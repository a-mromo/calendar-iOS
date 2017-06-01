//
//  PatientDetailVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/31/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class PatientDetailVC: UIViewController {
  
  var patient: Patient?
  
  @IBOutlet weak var patientNameLabel: UILabel!
  @IBOutlet weak var mobilePhoneLabel: UILabel!
  @IBOutlet weak var homePhoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  
  override func viewDidLoad() {
    setupUI()
  }
  
  func setupUI() {
    guard let patient = patient else { return }
    patientNameLabel.text = patient.fullName
    mobilePhoneLabel.text = patient.mobilePhone
    homePhoneLabel.text = patient.homePhone
    emailLabel.text = patient.email
    
    addBackButton()
  }
  
  func addBackButton(){
    let backButton = UIButton(type: .custom)
    backButton.setTitle("Back", for: .normal)
    backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
  }
  
  @IBAction func backAction(_ sender: UIButton) {
   dismiss(animated: true, completion: nil)
  }
  
}
