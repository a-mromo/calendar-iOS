//
//  PatientsTabTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/31/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class PatientsTabTVC: PatientsTableViewController {
  
  private let seguePatientDetail = "SeguePatientDetail"
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == seguePatientDetail {
      if let indexPath = tableView.indexPathForSelectedRow {
        let patient = fetchedResultsController.object(at: indexPath)
        let controller = (segue.destination as! PatientDetailVC)
        controller.patient = patient
        
      }
      
    }
  }
  
  
}

