//
//  ScreenshotterTest.swift
//  Spot
//
//  Created by Filip Melik on 10/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import XCTest

class ScreenshotterTest: XCTestCase {
    
    func testScreenshot() {
        // given 
        let screenshotter = Screenshotter()
        
        // when
        let screenshot = screenshotter.captureScreen()
        
        // then
        XCTAssertNotNil(screenshot)
    }
    
    func testScreenshotResolution() {
        // given
        let screenshotter = Screenshotter()
        
        // when
        let screenshot = screenshotter.captureScreen()
        
        if let screenshot = screenshot {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            // then
            XCTAssertEqual(screenshot.size.width, width)
            XCTAssertEqual(screenshot.size.height, height)
        } else {
            XCTFail()
        }
    }
    
}

// http://stackoverflow.com/questions/25146557/how-do-i-get-the-color-of-a-pixel-in-a-uiimage-with-swift
extension UIImage {
    func pixelColor(position: CGPoint) -> UIColor {
        var pixel : [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: UnsafeMutablePointer(mutating: pixel), width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        // Translate the context your required point(x,y)
        context!.translateBy(x: -(position.x), y: -(position.y));
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let redColor : Float = Float(pixel[0])/255.0
        let greenColor : Float = Float(pixel[1])/255.0
        let blueColor: Float = Float(pixel[2])/255.0
        let colorAlpha: Float = Float(pixel[3])/255.0
        
        // Create UIColor Object
        return UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: CGFloat(colorAlpha))
    }
    
}
