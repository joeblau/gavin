//
//  File.swift
//  
//
//  Created by Joe Blau on 8/3/19.
//

import Foundation

public enum WristLocation: Int {
    case left, right
}

extension WristLocation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        }
    }
}
