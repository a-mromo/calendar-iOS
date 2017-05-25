//
//  PatientsTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/22/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class PatientsTableViewController: UITableViewController {
  
  var patients = [Patient]()
  var selectedPatient: Patient?
  
  var managedObjectContext: NSManagedObjectContext!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    loadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadData()
  }
  
  func loadData() {
    let patientRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
    do {
      patients = try managedObjectContext.fetch(patientRequest)
      self.tableView.reloadData()
      print("Loading Data was successfull: PatientsList")
    } catch {
      print("Could not load data from datbase \(error.localizedDescription)")
    }
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return patients.count
  }
  
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientCell
   
   let patientObject = patients[indexPath.row]
    
    cell.patientNameLabel.text = patientObject.fullName
   
   return cell
   }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   self.selectedPatient = self.patients[indexPath.row] as Patient
   performSegue(withIdentifier: "patientSelected", sender: self)
  }
  
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "patientSelected" {
//      
//    }
//  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  
  
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
