//
//  WKInterfaceDevice+Extensions.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 8/3/19.
//

import WatchKit
import BlauProtocol

extension WKInterfaceDevice {
    var wrist: WristLocation {
        switch WKInterfaceDevice.current().wristLocation {
        case .left: return .left
        case .right: return .right
        @unknown default: fatalError("Unknown WKInterfaceDevice.current().wristLocation")
        }
    }
}
