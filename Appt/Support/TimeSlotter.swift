//
//  TimeSlotter.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/8/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class TimeSlotter {
  
  var openTime: Date!
  var closeTime: Date!
  var openTimeHour: Int!
  var openTimeMinutes: Int!
  var closeTimeHour: Int!
  var closeTimeMinutes: Int!
  
  var currentDate = Date()
  
  var appointmentLength: Int!
  var appointmentInterval: Int!
  var currentAppointments = [Date]()
  var possibleAppointments = [Date]()
  
  func configureTimeSlotter(openTimeHour: Int, openTimeMinutes: Int, closeTimeHour: Int, closeTimeMinutes: Int, appointmentLength: Int, appointmentInterval: Int) {
    self.openTimeHour = openTimeHour
    self.openTimeMinutes = openTimeMinutes
    self.closeTimeHour = closeTimeHour
    self.closeTimeMinutes = closeTimeMinutes
    self.appointmentLength = appointmentLength
    self.appointmentInterval = appointmentInterval
  }
  
  func setOfficeHoursForDate(date: Date) {
    openTime = createCompleteDate(year: date.year(), month: date.month(), withDay: date.day(), hour: openTimeHour, minute: openTimeMinutes)
    closeTime = createCompleteDate(year: date.year(), month: date.month(), withDay: date.day(), hour: closeTimeHour, minute: closeTimeMinutes)
  }
  
  func getTimeSlotsforDate(date: Date) -> [Date]? {
    setOfficeHoursForDate(date: date)
    setPossibleAppointments()
    checkAvailability()
    return possibleAppointments
  }
  
  func setPossibleAppointments() {
    let openMinutes = Calendar.current.dateComponents([.minute], from: openTime, to: closeTime).minute!
    
    // create a list of all appointments that would be possible throughout the day, regardless of actual availability
    let possibleAppointments = stride(from: 0, to: openMinutes, by: appointmentInterval).flatMap { Calendar.current.date(byAdding: .minute, value: $0, to: openTime) }
    self.possibleAppointments = possibleAppointments
  }
  
  
  func checkAvailability() {
    // check which of the theoretic timeslots aren't available and remove them from the list
    for possibleAppointmentStart in possibleAppointments {
      let possibleAppointmentEnd = Calendar.current.date(byAdding: .minute, value: appointmentLength, to: possibleAppointmentStart)!
      if possibleAppointmentEnd > closeTime {
        // if the appointment would end after closing time, it's obviously invalid
        if let appointmentIndex = possibleAppointments.index(of: possibleAppointmentStart) {
          possibleAppointments.remove(at: appointmentIndex)
          continue
        }
      }
      
      for existingAppointmentStart in currentAppointments {
        let existingAppointmentEnd = Calendar.current.date(byAdding: .minute, value: appointmentLength, to: existingAppointmentStart)!
        // see https://stackoverflow.com/a/5601502 for a list of relations between two interval. We are interested in "overlaps with"
        //
        // a interval overlaps a second interval if
        // - the interval starts earlier then the second intervals ends. And
        // - the second interval starts earlier than the first interval ends
        if possibleAppointmentStart < existingAppointmentEnd && existingAppointmentStart < possibleAppointmentEnd {
          if let appointmentIndex = possibleAppointments.index(of: possibleAppointmentStart) {
            possibleAppointments.remove(at: appointmentIndex)
            break
          }
        }
      }
    }
  }
  
  func createDate(withDay day: Int, hour: Int, minute: Int) -> Date {
    return DateComponents(calendar: Calendar.current, year: 2017, month: 7, day: day, hour: hour, minute: minute, second: 0).date!
  }
  
  func createCompleteDate(year: Int, month: Int, withDay day: Int, hour: Int, minute: Int) -> Date {
    return DateComponents(calendar: Calendar.current, timeZone: TimeZone(identifier: "US/Pacific"), year: year, month: month, day: day, hour: hour, minute: minute, second: 0).date!
  }
}
