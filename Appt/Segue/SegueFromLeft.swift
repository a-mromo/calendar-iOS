//
//  SegueFromLeft.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 6/20/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import QuartzCore

class SegueFromLeft: UIStoryboardSegue {
  
  override func perform() {
    let src: UIViewController = self.source
    let dst: UIViewController = self.destination
    let transition: CATransition = CATransition()
    let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.duration = 0.25
    transition.timingFunction = timeFunc
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromLeft
    src.navigationController!.view.layer.add(transition, forKey: kCATransition)
    src.navigationController!.pushViewController(dst, animated: false)
  }
  
}
