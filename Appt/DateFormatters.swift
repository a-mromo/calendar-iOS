//
//  DateFormatters.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/20/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import Foundation

func dateFormatter (date: Date) -> String{
  
  let formatter = DateFormatter()
  formatter.dateStyle = DateFormatter.Style.short
  formatter.timeStyle = .short
  
  let dateString = formatter.string(from: date as Date)
  return dateString
}

