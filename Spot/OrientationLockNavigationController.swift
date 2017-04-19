//
//  OrientationLockNavigationController.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import UIKit

class OrientationLockNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let leftNavBarButton = navigationBar.topItem?.leftBarButtonItem {
            leftNavBarButton.title = Spot.sharedInstance.leftNavigationBarButtonText
        }
        
        if let rightNavBarButton = navigationBar.topItem?.rightBarButtonItem {
            rightNavBarButton.title = Spot.sharedInstance.rightNavigationBarButtonText
        }
    }
    
    var orientationToLock: UIDeviceOrientation =  UIDeviceOrientation.portrait

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch orientationToLock {
            case .portrait:
                return UIInterfaceOrientationMask.portrait
        case .portraitUpsideDown:
            return UIInterfaceOrientationMask.portraitUpsideDown
        case .landscapeLeft:
            return UIInterfaceOrientationMask.landscapeLeft
        case .landscapeRight:
            return UIInterfaceOrientationMask.landscapeRight
        default:
            return UIInterfaceOrientationMask.portrait
        }
    }
}
