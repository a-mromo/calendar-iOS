//
//  TimeSlotsCVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/8/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit


class TimeSlotsCVC: UICollectionViewController {
  
  private let reuseIdentifier = "TimeSlotCell"
  
  
  var timeSlotter = TimeSlotter()
  var appointmentDate: Date!
  var formatter = DateFormatter()
  var timeSlots = [Date]()
  let currentDate = Date()
  var currentAppointments: [Appointment]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(appointmentDate)
    setupTimeSlotter()
  }
  
  func setupTimeSlotter() {
    timeSlotter.configureTimeSlotter(openTimeHour: 9, openTimeMinutes: 0, closeTimeHour: 17, closeTimeMinutes: 0, appointmentLength: 30, appointmentInterval: 15)
    if let appointmentsArray = currentAppointments {
      timeSlotter.currentAppointments = appointmentsArray.map { $0.date! }
    }
    guard let timeSlots = timeSlotter.getTimeSlotsforDate(date: appointmentDate) else {
      print("There is no appointments")
      return }
    
    self.timeSlots = timeSlots
  }
  

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return timeSlots.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
    
    cell.timeSlotView.layer.borderWidth = 2
    cell.timeSlotView.layer.borderColor = UIColor.darkGray.cgColor
    
    let timeSlot = timeSlots[indexPath.row]
    formatter.dateFormat = "H:mm"
    cell.timeLabel.text = formatter.string(from: timeSlot)

    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let destinationVC = self.navigationController?.viewControllers[0] as?  NewApptTableViewController {
      destinationVC.selectedTimeSlot = timeSlots[indexPath.row]
      self.navigationController?.popViewController(animated: true)
    } else if let destinationVC = self.navigationController?.viewControllers[0] as? UpdateApptTVC {
      destinationVC.selectedTimeSlot = timeSlots[indexPath.row]
      self.navigationController?.popViewController(animated: true)
    }
  }
  
}




