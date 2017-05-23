//
//  NewApptTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/17/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class NewApptTableViewController: UITableViewController {

//  var appointment = Appointment()
  var patient = Patient()
  
  var managedObjectContext: NSManagedObjectContext!
  
  var datePickerHidden = false
  
  @IBOutlet weak var patientNameTextField: UILabel!
  @IBOutlet weak var notesTextField: UITextField!
  @IBOutlet weak var costTextField: UITextField!
  
  @IBOutlet weak var dateDetailLabel: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  func createAppointmentObject() {
    let appointmentObject = Appointment(context: managedObjectContext)
    
    appointmentObject.patient?.name = patientNameTextField.text
    appointmentObject.date = datePicker.date as NSDate
    appointmentObject.note = notesTextField.text
    if let cost = Int16(costTextField.text!) {
      appointmentObject.cost = cost
    }
    do {
      try self.managedObjectContext.save()
      print("Save was succesful")
    } catch {
      print("Could not save data \(error.localizedDescription)")
    }
  }
  
  @IBAction func confirmAppointment(_ sender: UIBarButtonItem) {
    createAppointmentObject()
  }
    override func viewDidLoad() {
        super.viewDidLoad()
managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      datePickerChanged()
    }

  @IBAction func datePickerValue(_ sender: UIDatePicker) {
    datePickerChanged()
  }
  
  func datePickerChanged() {
    dateDetailLabel.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
  }
  
  func toggleDatePicker() {
    datePickerHidden = !datePickerHidden
    
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      toggleDatePicker()
    }
    if indexPath.section == 1 && indexPath.row == 0 {
      
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
      return 0
    } else{
      return super.tableView(tableView, heightForRowAt: indexPath)
    }

  }
  
  
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
