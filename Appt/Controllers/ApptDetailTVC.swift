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
    noLargeTitles()
    setupUI()
  }
  
  func noLargeTitles(){
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
      tableView.dragDelegate = self as? UITableViewDragDelegate
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupUI()
  }
  
  @IBAction func editAppt(_ sender: UIButton) {
    performSegue(withIdentifier: segueEditAppt, sender: self)
  }
  
  func setupUI() {
    guard let appointment = self.appointment else { return }
      dateLabel.text = dateFormatter(date: appointment.date)
      patientNameLabel.text = appointment.patient.fullName
    
    if appointment.cost != nil {
      apptCostLabel.text = String(describing: appointment.cost)
    }
    if appointment.note != nil {
      noteLabel.text = appointment.note
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueEditAppt {
      if let destinationNavigationViewController = segue.destination as? UINavigationController {
        let controller = (destinationNavigationViewController.topViewController as! UpdateApptTVC)
        controller.appointment = appointment
        controller.appointmentLoaded = true
      }
    }
  }
}
