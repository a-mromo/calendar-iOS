//
//  Appointment+CoreDataProperties.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 5/17/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var cost: Int16
    @NSManaged public var date: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var patient: Patient?

}
