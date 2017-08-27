//
//  Patient+CoreDataProperties.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/31/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import Foundation
import CoreData


extension Patient {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
    return NSFetchRequest<Patient>(entityName: "Patient")
  }
  
  @NSManaged public var email: String?
  @NSManaged public var homePhone: String?
  @NSManaged public var lastName: String
  @NSManaged public var mobilePhone: String?
  @NSManaged public var name: String
  @NSManaged public var appointment: NSSet?
  
  public var fullName: String {
      return name + " " + lastName
  }
  
}

// MARK: Generated accessors for appointment
extension Patient {
  
  @objc(addAppointmentObject:)
  @NSManaged public func addToAppointment(_ value: Appointment)
  
  @objc(removeAppointmentObject:)
  @NSManaged public func removeFromAppointment(_ value: Appointment)
  
  @objc(addAppointment:)
  @NSManaged public func addToAppointment(_ values: NSSet)
  
  @objc(removeAppointment:)
  @NSManaged public func removeFromAppointment(_ values: NSSet)
  
}
