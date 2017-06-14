//
//  SpotIssueData.swift
//  Spot
//
//  Created by Filip Melik on 08/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import Foundation
import UIKit

/// Container for data about issue
public struct SpotIssueData {

    
    //
    // MARK: - Properties
    //
    
    
    private(set) var originalScreenshot: UIImage?
    private(set) var combinedScreenshot: UIImage?
    private(set) var metadata = IssueMetadata()

    private(set) var customIssueData: String?
    
    
    //
    // MARK: - Computed properties
    //
    
    
    var originalScreenshotData: Data? {
        var screenshotData: Data?

        if let screenshot = originalScreenshot {
            screenshotData = UIImagePNGRepresentation(screenshot)
        }
        
        return screenshotData
    }
    
    var combinedScreenshotData: Data? {
        var combinedImageData: Data?

        if let combinedImage = combinedScreenshot {
            combinedImageData = UIImagePNGRepresentation(combinedImage)
        }
        
        return combinedImageData
    }
    

    //
    // MARK: - Init
    //
    
    
    init(originalScreenshot: UIImage?, combinedImage: UIImage?, customIssueData: String?) {
        self.originalScreenshot = originalScreenshot
        self.combinedScreenshot = combinedImage
        self.customIssueData = customIssueData
    }
    
}
