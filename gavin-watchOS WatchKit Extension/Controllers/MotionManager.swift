//
//  MotionManager.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 6/29/19.
//

import os.log
import Foundation
import CoreMotion
import Combine

class MotionManger {
    fileprivate let SAMPLE_INTERVAL = 0.02  // 50hz
    fileprivate let queue = OperationQueue()
    fileprivate let motionManager = CMMotionManager()
    fileprivate let subject = PassthroughSubject<CMDeviceMotion, Never>()
    
    init() {
        motionManager.deviceMotionUpdateInterval = SAMPLE_INTERVAL

        queue.maxConcurrentOperationCount = 1
        queue.name = "motion_manager_queue"
    }
    
    public func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            os_log("device motion not available",
                   log: .default,
                   type: .error)
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion, error) in
            if let error = error {
                os_log("error starting deivce motions updates %@",
                       log: .default,
                       type: .error,
                       error.localizedDescription)
            }
            
            if let deviceMotion = deviceMotion {
                self.subject.send(deviceMotion)
            }
        }
    }
    
    public func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}
