//
//  ApptDetailTVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/20/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class ApptDetailTVC: UITableViewController {
  
  var appointment: Appointment? 
  
  var segueEditAppt = "SegueEditAppt"
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var patientNameLabel: UILabel!
  @IBOutlet weak var apptCostLabel: UILabel!
  @IBOutlet weak var noteLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupUI()
  }
  
  @IBAction func editAppt(_ sender: UIButton) {
    performSegue(withIdentifier: segueEditAppt, sender: self)
  }
  
  func setupUI () {
    if let date = appointment?.date, let patientName = appointment?.patient?.fullName, let cost = appointment?.cost, let note = appointment?.note {
      
      dateLabel.text = dateFormatter(date: date)
      patientNameLabel.text = patientName
      apptCostLabel.text = String(cost)
      noteLabel.text = note
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueEditAppt {
      if let destinationNavigationViewController = segue.destination as? UINavigationController {
        let controller = (destinationNavigationViewController.topViewController as! UpdateApptTVC)
        controller.appointment = appointment
      }
    }
  }
}
