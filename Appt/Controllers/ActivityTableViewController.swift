//
//  ActivityTableViewController.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/1/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import CoreData

class ActivityTableViewController: CalendarTableViewController {
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
    
    let appointment = fetchedResultsController.object(at: indexPath)
    
    var patientName = ""
    var apptDate = ""
    
    if let patient = appointment.patient?.fullName,
      let date = appointment.date,
      let dateCreated = appointment.dateCreated
    {
      patientName = patient
      cell.timeIntervalLabel.text = dateFormatter(date: date)
      apptDate = dateFormatter(date: date)
      let timeAgo:String = timeAgoSinceDate(dateCreated, currentDate: Date(), numericDates: true)
      cell.timeIntervalLabel.text = timeAgo
    }
    
    cell.activityLabel.text = "New appointment with \(String(describing: patientName)) for \(apptDate)"
    return cell
  }
  
}


