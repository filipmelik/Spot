//
//  ImageCombiner.swift
//  Spot
//
//  Created by Filip Melik on 10/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import UIKit

class ImageCombiner {
    
    
    /// Combine two images.
    ///
    /// - Parameters:
    ///   - bottomImage: Image placed on the bottom.
    ///   - topImage: Image placed onto the the bottom image.
    /// - Returns: Combined image. If no topImage supplied, return nil.
    func combine(bottom bottomImage: UIImage, with topImage: UIImage?) -> UIImage? {
        var combinedImage: UIImage?
        
        if let topImage = topImage {
            UIGraphicsBeginImageContextWithOptions(bottomImage.size, false, 0.0)
            
            bottomImage.draw(in: CGRect.init(x: 0, y: 0, width: topImage.size.width, height: topImage.size.height))
            topImage.draw(in: CGRect.init(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height))
            
            combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return combinedImage
    }
    
}
