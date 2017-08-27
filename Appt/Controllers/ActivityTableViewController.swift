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
    //      cell.timeIntervalLabel.text = dateFormatter(date: appointment.date)
    let timeAgo:String = timeAgoSinceDate(appointment.dateCreated, currentDate: Date(), numericDates: true)
    
    cell.timeIntervalLabel.text = timeAgo
    cell.activityLabel.text = "New appointment with \(String(describing: appointment.patient.fullName)) for \(dateFormatter(date: appointment.date))"
    
    return cell
  }
  
}


