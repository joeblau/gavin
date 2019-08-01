//
//  WKInterfaceDeviceWristLocation+Extensions.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 7/31/19.
//

import WatchKit

extension WKInterfaceDeviceWristLocation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left: return "Left"
        case .right: return "Right"
        @unknown default: fatalError()
        }
    }
}
