//
//  SpotMailSender.swift
//  Spot
//
//  Created by Filip Melik on 09/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

/// Implementation of SpotSender protocol that allows to send issue data through e-mail.
/// Note: If you want to localize labels or alter the behavior, you have to create a subclass and override the behavior.
class SpotMailSender: NSObject, SpotSender, MFMailComposeViewControllerDelegate {
    
    
    //
    // MARK: - Appearance properties
    //
    
    
    var alertErrorTitle = "Error"
    var alertOKLabelText = "OK"
    var noEmailAccountsText = "No e-mail accounts available"
    var issueSubjectPostfix = "issue"
    
    
    //
    // MARK: - Properties
    //
    
    
    /// Parent view controller.
    var spotViewController: SpotViewController?
    
    
    //
    // MARK: - SpotSender
    //
    
    
    func send(data: SpotIssueData) {
        showEmail(issueData: data)
    }
    
    
    //
    // MARK: - Private
    //
    
    
    /// Show view controller with pre-composed e-mail.
    ///
    /// - Parameter issueData: Issue data and metadata.
    private func showEmail(issueData: SpotIssueData) {
        if MFMailComposeViewController.canSendMail() {
            let mailViewController = MFMailComposeViewController()
            mailViewController.mailComposeDelegate = self
            mailViewController.setSubject("\(issueData.metadata.appName) \(issueSubjectPostfix)")
            mailViewController.setMessageBody(deviceAppInfo(issueData: issueData), isHTML: false)
            
            if let combinedImageData = issueData.combinedScreenshotData {
                mailViewController.addAttachmentData(combinedImageData, mimeType: "image/png", fileName: "annotatedScreenshot.png")
            }
            
            if let screenshotData = issueData.originalScreenshotData {
                mailViewController.addAttachmentData(screenshotData, mimeType: "image/png", fileName: "originalScreenshot.png")
            }
            
            spotViewController?.present(mailViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: alertErrorTitle,
                message: noEmailAccountsText,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: alertOKLabelText, style: UIAlertActionStyle.cancel) { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            
            spotViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /// Get basic device app info to be sent in e-mail body.
    ///
    /// - Parameter issueData: Issue data and metadata.
    /// - Returns: Device info string.
    private func deviceAppInfo(issueData: SpotIssueData) -> String {
        let versionNumber = issueData.metadata.appVersionNumber
        let buildNumber = issueData.metadata.appBuildNumber
        let bundleName = issueData.metadata.appName
        
        var bodyText = "Device info\nBundle name: \(bundleName)\nVersion: \(versionNumber)\nBuild: \(buildNumber)\n"
        if let modelName = issueData.metadata.deviceModelName {
            bodyText += "Device: \(modelName)"
        }
        
        return bodyText
    }
    
    
    //
    // MARK: MFMailComposeViewControllerDelegate
    //
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        spotViewController?.dismiss(animated: true, completion: nil)
    }
    
}
