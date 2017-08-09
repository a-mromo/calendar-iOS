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
  
  
  
  
  var timeSlots: [String] = ["8:00", "8:30", "9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"]
  var array = [String]()
  let currentDate = Date()
  var nextHour = 0
  var nextMinute = 0
  var forLoop = 0
  let appointmentMinuteLength = 30
  let closingHour = 23
  
  func setupTimeSlotter() {
    timeSlotter.configureTimeSlotter(openTimeHour: 8, openTimeMinutes: 0, closeTimeHour: 10, closeTimeMinutes: 0, appointmentLength: 30, appointmentInterval: 15)
    guard let timeSlots = timeSlotter.getTimeSlotsforDate(date: currentDate) else { return }
    print("TIme Slots: \(timeSlots)")
    timeSlots.map { print("\($0.hour()):\($0.minute())") }

  }
  
  func timeSlotIterarate() {
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTimeSlotter()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using [segue destinationViewController].
   // Pass the selected object to the new view controller.
   }
   */
  
  // MARK: UICollectionViewDataSource
  
  func timeSlotsByConditions() {
    
    print("Current Time: \(currentDate.hour().description) : \(currentDate.minute())")
    
    if currentDate.minute() > appointmentMinuteLength {
      nextHour = currentDate.hour()+1
      nextMinute = appointmentMinuteLength
    } else{
      nextHour = currentDate.hour()+1
      nextMinute = 0
    }
    
    if nextMinute == 0 {
      forLoop = (closingHour - nextHour-1)
      for index in 0 ... forLoop{
        array.append("\(nextHour+index):00")
        array.append("\(nextHour+index):30")
      }
      array.append("21:00")
    } else {
      forLoop = (closingHour - nextHour - 1)
      
      for index in 0 ... forLoop{
        array.append("\(nextHour+index):00")
        array.append("\(nextHour+index):30")
      }
      array.append("\(closingHour):00")
    }
  }
  
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return array.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
    
    
    cell.timeLabel.text = array[indexPath.row]
    
    // Configure the cell
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
  
  
}

