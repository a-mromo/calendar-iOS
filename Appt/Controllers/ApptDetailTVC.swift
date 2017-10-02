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
  
  @IBOutlet weak var hourLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var patientNameLabel: UILabel!
  @IBOutlet weak var apptCostLabel: UILabel!
  @IBOutlet weak var noteTextView: UITextView!
  
  @IBOutlet weak var editApptButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    noLargeTitles()
    setupUI()
    navBarDropShadow()
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
  
  override func viewWillDisappear(_ animated: Bool) {
    navBarNoShadow()
  }
  
  @IBAction func editAppt(_ sender: UIButton) {
    performSegue(withIdentifier: segueEditAppt, sender: self)
  }
  
  func setupUI() {
    guard let appointment = self.appointment else { return }
      dateLabel.text = dateFormatter(date: appointment.date)
      let apptTimeStart = appointment.date
      let apptTimeEnd = appointment.date + 1800
    hourLabel.text = "\(hourFormatter(date: apptTimeStart)) - \(hourFormatter(date: apptTimeEnd))"
      patientNameLabel.text = appointment.patient.fullName
    
    if let cost = appointment.cost {
      apptCostLabel.text = "$\(cost)"
    }
    if let note = appointment.note {
      noteTextView.text = "\(note)"
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
  
  func navBarDropShadow() {
    self.navigationController?.navigationBar.layer.masksToBounds = false
    self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
    self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
    self.navigationController?.navigationBar.layer.shadowRadius = 4
  }
  
  func navBarNoShadow(){
    self.navigationController?.navigationBar.layer.masksToBounds = true
    self.navigationController?.navigationBar.layer.shadowColor = .none
    self.navigationController?.navigationBar.layer.shadowOpacity = 0
    self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.navigationController?.navigationBar.layer.shadowRadius = 0
  }
}
