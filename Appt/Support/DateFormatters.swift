//
//  DateFormatters.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/20/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import Foundation
import UIKit

func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
  let calendar = Calendar.current
  let now = currentDate
  let earliest = (now as NSDate).earlierDate(date)
  let latest = (earliest == now) ? date : now
  let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
  
  if (components.year! >= 2) {
    return "\(components.year!) years ago"
  } else if (components.year! >= 1){
    if (numericDates){
      return "1 year ago"
    } else {
      return "Last year"
    }
  } else if (components.month! >= 2) {
    return "\(components.month!) months ago"
  } else if (components.month! >= 1){
    if (numericDates){
      return "1 month ago"
    } else {
      return "Last month"
    }
  } else if (components.weekOfYear! >= 2) {
    return "\(components.weekOfYear!) weeks ago"
  } else if (components.weekOfYear! >= 1){
    if (numericDates){
      return "1 week ago"
    } else {
      return "Last week"
    }
  } else if (components.day! >= 2) {
    return "\(components.day!) days ago"
  } else if (components.day! >= 1){
    if (numericDates){
      return "1 day ago"
    } else {
      return "Yesterday"
    }
  } else if (components.hour! >= 2) {
    return "\(components.hour!) hours ago"
  } else if (components.hour! >= 1){
    if (numericDates){
      return "1 hour ago"
    } else {
      return "An hour ago"
    }
  } else if (components.minute! >= 2) {
    return "\(components.minute!) minutes ago"
  } else if (components.minute! >= 1){
    if (numericDates){
      return "1 minute ago"
    } else {
      return "A minute ago"
    }
  } else if (components.second! >= 3) {
    return "\(components.second!) seconds ago"
  } else {
    return "Just now"
  }
}


func dateFormatter (date: Date) -> String{
  let formatter = DateFormatter()
  formatter.dateStyle = .long
  formatter.timeStyle = .none
  
  let dateString = formatter.string(from: date as Date)
  return dateString
}

func hourFormatter (date: Date) -> String{
  let formatter = DateFormatter()
  formatter.dateStyle = .none
  formatter.timeStyle = .short
  
  let dateString = formatter.string(from: date as Date)
  return dateString
}


func createCompleteDate(year: Int, month: Int, withDay day: Int, hour: Int, minute: Int) -> Date {
  return DateComponents(calendar: Calendar.current, timeZone: TimeZone(identifier: "US/Pacific"), year: year, month: month, day: day, hour: hour, minute: minute, second: 0).date!
}

