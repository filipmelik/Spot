//
//  ScreenshotViewController.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import UIKit

/// Drawing code taken from https://github.com/FlexMonkey/ForceSketch
class ScreenshotViewController: UIViewController {
    
    
    //
    // MARK: - Properties
    //
    
    
    /// Outlets
    @IBOutlet weak var screenshotImageView: UIImageView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var promptLabelHeightConstraint: NSLayoutConstraint!
    
    /// Screenshot taken from the current screen.
    var screenshot: UIImage?
    
    /// Text to be displayed in prompt label.
    var promptLabelText: String?
    
    /// Prompt label background color.
    var promptLabelBackgroundColor: UIColor?
    
    /// Prompt label text color.
    var promptLabelTextColor: UIColor?
    
    /// Image view where the user draws
    let imageView = UIImageView()
    
    /// Issue sender implementation ("transport layer")
    var spotSender: SpotSender?
    
    /// Drawing properties
    let hsb = CIFilter(name: "CIColorControls", withInputParameters: [kCIInputBrightnessKey: 0.05])!
    let gaussianBlur = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey: 1])!
    let compositeFilter = CIFilter(name: "CISourceOverCompositing")!
    var imageAccumulator: CIImageAccumulator!
    var previousTouchLocation: CGPoint?

    /// Object that can handle combining images.
    private var imageCombiner = ImageCombiner()

    
    //
    // MARK: - VC Lifecycle
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let screenshot = screenshot, let screenshotImageView = screenshotImageView {
            screenshotImageView.image = screenshot
        }
        
        if let text = promptLabelText, let bgColor = promptLabelBackgroundColor, let textColor = promptLabelTextColor {
            promptLabel.text = text
            promptLabel.textColor = textColor
            promptLabel.backgroundColor = bgColor
        } else {
            promptLabelHeightConstraint.constant = 0
        }
        
        imageAccumulator = CIImageAccumulator(extent: view.frame, format: kCIFormatARGB8)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        
        self.view.setNeedsUpdateConstraints(); // bootstrap Auto Layout
    }
    
    
    //
    // MARK: - Action handlers
    //
    
    
    @IBAction func pressedSend(_ sender: Any) {
        let combinedImage = imageCombiner.combine(bottom: screenshot!, with: imageView.image)
        
        let issueData = SpotIssueData(originalScreenshot: screenshot, combinedImage: combinedImage)
        
        if let sender = spotSender {
            if let spotEmailSender = sender as? SpotMailSender {
                spotEmailSender.spotViewController = self
            }
            
            sender.send(data: issueData)
        }
    }
    
    @IBAction func pressedCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    //
    // MARK: - Drawing code
    //
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = touches.first?.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let event = event,
            let coalescedTouches = event.coalescedTouches(for: touch) else {
            return
        }
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        if let cgContext = UIGraphicsGetCurrentContext() {
        
            cgContext.setLineCap(CGLineCap.round)
            
            for coalescedTouch in coalescedTouches {
                let lineWidth: CGFloat
                if coalescedTouch.force != 0 {
                    lineWidth = (coalescedTouch.force / coalescedTouch.maximumPossibleForce) * 20
                }
                else {
                    lineWidth = 10
                }

                let lineColor = UIColor.blue.cgColor
                
                cgContext.setLineWidth(lineWidth)
                cgContext.setStrokeColor(lineColor)
                
                cgContext.move(to: previousTouchLocation!)
                cgContext.addLine(to: coalescedTouch.location(in: view))
                cgContext.strokePath()
                
                previousTouchLocation = coalescedTouch.location(in: view)
            }
            
            let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            compositeFilter.setValue(CIImage(image: drawnImage!),
                                     forKey: kCIInputImageKey)
            compositeFilter.setValue(imageAccumulator.image(),
                                     forKey: kCIInputBackgroundImageKey)
            
            imageAccumulator.setImage(compositeFilter.value(forKey: kCIOutputImageKey) as! CIImage)
            
            imageView.image = UIImage(ciImage: imageAccumulator.image())
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = nil
    }
    
    
    //
    // MARK: - Overrides
    //
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}


