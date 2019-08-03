//
//  File.swift
//  
//
//  Created by Joe Blau on 8/2/19.
//

import Foundation
import CoreMotion

public enum Wrist: Int {
    case left, right
}

public struct GyroscopeSensor {
    var wrist: Wrist
    var gyroData: CMGyroData
    
    public init(wrist: Wrist, gyroData: CMGyroData) {
        self.wrist = wrist
        self.gyroData = gyroData
    }
}
