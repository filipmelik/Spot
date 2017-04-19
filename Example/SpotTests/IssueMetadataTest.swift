//
//  IssueMetadataTest.swift
//  Spot
//
//  Created by Filip Melik on 10/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import Foundation
import XCTest

class IssueMetadataTest: XCTestCase {
    
    func testDeviceModelName() {
        // given
        let issueMetadata = IssueMetadata()
        
        // when
        let model = issueMetadata.deviceModelName
        
        // then
        XCTAssertNotNil(model)
    }
    
    func testAppName() {
        // given
        let issueMetadata = IssueMetadata()
        
        // when
        let appName = issueMetadata.appName
        
        // then
        XCTAssertNotNil(appName)
        XCTAssertEqual(appName, "Spot")
    }
    
    func testDeviceAppVersionNumber() {
        // given
        let issueMetadata = IssueMetadata()
        
        // when
        let appVersionNumber = issueMetadata.appVersionNumber
        
        // then
        XCTAssertNotNil(appVersionNumber)
    }
    
    
    func testDeviceAppBuildNumber() {
        // given
        let issueMetadata = IssueMetadata()
        
        // when
        let appBuildNumber = issueMetadata.appBuildNumber
        
        // then
        XCTAssertNotNil(appBuildNumber)
    }
    
}
