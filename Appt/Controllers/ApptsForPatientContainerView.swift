//
//  ApptsForPatientContainerView.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 10/2/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class ApptsForPatientContainerView: UIViewController {
  
  var testArray = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item"]
  var patient: Patient?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
    if let patientPassed = patient {
      print("Patient was succesfully passed: \(patientPassed.fullName)")
    } else {
      print("ERROR: Couldn't passed patient between views")
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

