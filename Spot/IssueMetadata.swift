//
//  IssueMetadata.swift
//  Spot
//
//  Created by Filip Melik on 10/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import Foundation

/// Container for issue metadata = device and app info.
struct IssueMetadata {
    
    let appVersionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let appBuildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    
    var deviceModelName: String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
}
