//
//  SpotSenderProtocol.swift
//  Spot
//
//  Created by Filip Melik on 08/02/2017.
//  Copyright © 2017 Daniel Leivers. All rights reserved.
//

import Foundation

/// Protocol that allows to use custom issue sender - email, github, custom solution... whatever you want.
protocol SpotSender {
    func send(data: SpotIssueData)
}
