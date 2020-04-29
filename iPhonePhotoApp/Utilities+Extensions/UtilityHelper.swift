//
//  UtilityHelper.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 29/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation

class UtilityHelper {

    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
