//
//  ImageCombinerTest.swift
//  Spot
//
//  Created by Filip Melik on 10/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import Foundation
import XCTest

class ImageCombinerTest: XCTestCase {
    
    func testCombineImages() {
        // given
        let imageCombiner = ImageCombiner()
        
        let rect = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        UIGraphicsBeginImageContext(rect.size);
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            
            context.setFillColor(UIColor.blue.cgColor)
            context.fill(CGRect.init(x: 0, y: 0, width: 50, height: 100))
            let topImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            
            context.setFillColor(UIColor.red.cgColor)
            context.fill(rect)
            let bottomImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let bottomImage = bottomImage, let topImage = topImage {
                // when + then
                if let combinedImage = imageCombiner.combine(bottom: bottomImage, with: topImage) {
                    XCTAssertNotNil(combinedImage)
                    
                    let leftColor = combinedImage.pixelColor(position: CGPoint.init(x: 25, y: 50))
                    let rightColor = combinedImage.pixelColor(position: CGPoint.init(x: 75, y: 50))
                    
                    XCTAssertEqual(leftColor, UIColor.blue)
                    XCTAssertEqual(rightColor, UIColor.red)
                }
                else {
                    XCTFail()
                }
            }
            else {
                XCTFail()
            }
        }
        else {
            XCTFail()
        }
    }
    
}
