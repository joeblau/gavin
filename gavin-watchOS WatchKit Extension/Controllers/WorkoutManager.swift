//
//  WorkoutManager.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 6/29/19.
//

import Foundation
import HealthKit
import os.log

class WorkoutManager: NSObject {

    fileprivate let motionManager = MotionManger()
    fileprivate let workoutConfiguration = HKWorkoutConfiguration()
    fileprivate let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    
    
    override init() {
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .unknown
        super.init()
    }
    
    public func startWorkout() {
        session = try? HKWorkoutSession(healthStore: healthStore,
                                        configuration: workoutConfiguration)
        session?.delegate = self
        session?.startActivity(with: Date())
    }
    
    public func stopWorkout() {
        session?.stopActivity(with: Date())
        session = nil
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        switch toState {
        case .notStarted:
            os_log("workout session state: not started",
                   log: .default,
                   type: .info)
        case .prepared:
            os_log("workout session state: prepared",
                   log: .default,
                   type: .info)
        case .running:
            motionManager.startUpdates()
        case .paused:
            os_log("workout session state: paused",
                   log: .default,
                   type: .info)
        case .stopped:
            motionManager.stopUpdates()
        case .ended:
            os_log("workout session state: ended",
                   log: .default,
                   type: .info)
        @unknown default: fatalError()
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        workoutSession.stopActivity(with: Date())
    }
}
