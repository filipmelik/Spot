//
//  UIWindow+ShakeGesture.swift
//  Spot
//
//  Created by Filip Melik on 10/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import UIKit

/// Extension that enables device to listen to shake gesture.
extension UIWindow {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if Spot.sharedInstance.enableWithShakeGesture {
            Spot.sharedInstance.launch()
        }
    }
}
