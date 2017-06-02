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
    if let patient = appointment.patient?.fullName {
      patientName = patient
    }
    var apptDate = ""
    
    
    
    if let date = appointment.date {
      cell.timeIntervalLabel.text = dateFormatter(date: date)
      apptDate = dateFormatter(date: date)
    }
    if let dateCreated = appointment.dateCreated {
      cell.timeIntervalLabel.text = timeIntervalFormatter(date: dateCreated)
    }
    
    cell.activityLabel.text = "New appointment with \(String(describing: patientName)) for \(apptDate)"
    
    
    return cell
  }
  
  
  func timeIntervalFormatter(date: Date) -> String {
    let now = Date()
    
    let calender:Calendar = Calendar.current
    let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
    print(components)
    var returnString:String = ""
    print(components.second ?? "")
    if components.second! < 60 {
      returnString = "Just Now"
    }else if components.minute! >= 1{
      returnString = String(describing: components.minute) + " min ago"
    }else if components.hour! >= 1{
      returnString = String(describing: components.hour) + " hour ago"
    }else if components.day! >= 1{
      returnString = String(describing: components.day) + " days ago"
    }else if components.month! >= 1{
      returnString = String(describing: components.month)+" month ago"
    }else if components.year! >= 1 {
      returnString = String(describing: components.year)+" year ago"
    }
    return returnString
  }
  
}
