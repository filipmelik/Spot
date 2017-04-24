//
//  ViewController.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func launchSpotWithButtonPress(_ sender: Any) {
        
        if let button = sender as? UIButton {
            button.isHidden = true
            print("Button was set to hidden, so it does not appear in the screenshot.")
        }
        
        Spot.sharedInstance.launch()
    }

}

