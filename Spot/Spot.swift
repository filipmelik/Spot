//
//  Spot.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import UIKit

public class Spot: NSObject {

    
    //
    // MARK: - Appearance Properties
    //


    /// Text displayed in left button of navigation bar.
    public var leftNavigationBarButtonText = "Cancel"

    /// Text displayed in right button of navigation bar.
    public var rightNavigationBarButtonText = "Send"

    /// Text prompt displayed above taken screenshot. Set to nil to display no text prompt.
    public var promptLabelText: String? = "Please mark an error in the image."
    
    /// Prompt label background color.
    public var promptLabelBackgroundColor = UIColor.gray
    
    /// Prompt label text color.
    public var promptLabelTextColor = UIColor.white

    /// Custom string passed along with issue.
    public var customIssueData: String? = nil
    

    //
    // MARK: - Properties
    //


    /// Enable Spot with shake gesture?
    public var enableWithShakeGesture: Bool = false

    /// Spot "transport layer" - Defaults to e-mail, but you can create custom and send issue data wherever you want
    /// by adopting SpotSender protocol.
    public var spotSender: SpotSender = SpotMailSender()

    /// Spot singleton instance.
    public static let sharedInstance = Spot()

    /// Screenshot taker.
    private let screenshotter = Screenshotter()
    

    //
    // MARK: - Functions
    //


    public static func startListeningForShakeGesture() {
        sharedInstance.enableWithShakeGesture = true
    }
    
    public static func stopListeningForShakeGesture() {
        sharedInstance.enableWithShakeGesture = false
    }
    

    /// Take screenshot of current screen and show the view controller with taken screenshot and send options.
    public func launch() {
        if let screenshot = screenshotter.captureScreen() {
            loadViewControllers(withScreenshot: screenshot)
        }
    }
    

    //
    // MARK: - Private
    //
    

    /// Load view controller that allows user to mark issue in the screenshot by drawing.
    ///
    /// - Parameter screenshot: Screenshot into which the user will be able to draw.
    private func loadViewControllers(withScreenshot screenshot: UIImage) {
        guard let initialViewController = loadSpotViewController() else { return }
        guard let topViewController = topViewController() else { return }

        initialViewController.orientationToLock = UIDevice.current.orientation
        if ((topViewController as? OrientationLockNavigationController) != nil) {
            // We're already presenting an instance of Spot!
            return
        }
        else {
            topViewController.present(initialViewController, animated: true, completion: nil)
            if let screenshotViewController = initialViewController.topViewController as? ScreenshotViewController {
                screenshotViewController.screenshot = screenshot
                screenshotViewController.spotSender = spotSender
                screenshotViewController.promptLabelText = promptLabelText
                screenshotViewController.promptLabelBackgroundColor = promptLabelBackgroundColor
                screenshotViewController.promptLabelTextColor = promptLabelTextColor
                screenshotViewController.customIssueData = customIssueData
            }
        }

    }

    
    /// Create Spot view controller.
    ///
    /// - Returns: OrientationLockNavigationController or nil, if view controller instantiating fails.
    private func loadSpotViewController() -> OrientationLockNavigationController? {
        // Handle pod bundle (if installed via 'pod install') or local for example
        var storyboard: UIStoryboard
        let podBundle = Bundle(for: object_getClass(self))
        if let bundleURL = podBundle.url(forResource: "Spot", withExtension: "bundle") {
            guard let bundle = Bundle(url: bundleURL) else { return nil }
            storyboard = UIStoryboard.init(name: "Spot", bundle: bundle)
        }
        else {
            storyboard = UIStoryboard.init(name: "Spot", bundle: nil)
        }

        if let initialViewController = storyboard.instantiateInitialViewController() as? OrientationLockNavigationController {
            return initialViewController
        }
        else {
            return nil
        }
    }


    /// Get currently presented view controller (the topmost view controller).
    ///
    /// - Returns: View Controller.
    private func topViewController() -> UIViewController? {
        if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            return topViewController
        }

        return nil
    }

}
