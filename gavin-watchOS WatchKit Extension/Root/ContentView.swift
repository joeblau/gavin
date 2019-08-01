//
//  ContentView.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 7/31/19.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    var wrist: String
    let workoutManager = WorkoutManager()
    
    var body: some View {
        VStack {
            Text("Wrist \(wrist)")
            Button(action: {
                switch self.workoutManager.session {
                case .some: self.workoutManager.stopWorkout()
                case .none: self.workoutManager.startWorkout()
                }
            }) {
                Text(self.workoutManager.session?.state == .running ? "Stop" : "Start")
            }
        }
        .padding()
        .navigationBarTitle(Text("⌚️ \(wrist)"))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(wrist: "Right")
    }
}
#endif
