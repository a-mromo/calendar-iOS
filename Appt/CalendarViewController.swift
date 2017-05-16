//
//  CalendarViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/15/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBAction func addApptModally(_ sender: UIBarButtonItem) {
    
  }
  
  var appointments = [Appointment]()
  
  var managedObjectContext: NSManagedObjectContext!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    loadData()
  }
  
  func loadData() {
    let appointmentRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest()
    
    do {
      appointments = try managedObjectContext.fetch(appointmentRequest)
      self.tableView.reloadData()
    } catch {
      print("Could not load data from datbase \(error.localizedDescription)")
    }
  }

  @IBAction func addAppointment(_ sender: UIBarButtonItem) {
    
    createAppointmentObject()
    
  }
  
  
  func createAppointmentObject () {
    
    let appointmentObject = Appointment(context: managedObjectContext)
    
    let inputAlert = UIAlertController(title: "New Appointment", message: "Add a new Appointment", preferredStyle: .alert)
    inputAlert.addTextField { (textfield: UITextField) in
      textfield.placeholder = "Patient Name"
    }
    inputAlert.addTextField { (textfield: UITextField) in
      textfield.placeholder = "Appointment Date"
    }
    inputAlert.addTextField { (textfield: UITextField) in
      textfield.placeholder = "Description"
    }
    
    inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) in
      
      let patientTextField = inputAlert.textFields?.first
      let dateTextField = inputAlert.textFields?[1]
      let noteTextField = inputAlert.textFields?.last
      
      if patientTextField?.text != "" && dateTextField?.text != "" && noteTextField?.text != "" {
        appointmentObject.fullName = patientTextField?.text
        appointmentObject.date = dateTextField?.text
        appointmentObject.note = noteTextField?.text
        
        do {
          try self.managedObjectContext.save()
          self.loadData()
        } catch {
          print("Could not save data \(error.localizedDescription)")
        }
      }
    }))
    
    inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(inputAlert, animated: true, completion:  nil)
    
  }
}


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return appointments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
    
    let apptObject = appointments[indexPath.row]
    
    cell.nameLabel.text = apptObject.fullName
    cell.dateLabel.text = apptObject.date
    cell.noteLabel.text = apptObject.note
    
    return cell
  }
}

