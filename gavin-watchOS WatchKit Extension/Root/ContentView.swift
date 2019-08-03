//
//  ContentView.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 7/31/19.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var watchState: WatchState
    
    var wrist: String
    let workoutManager = WorkoutManager()
    
    var body: some View {
        VStack {
            HStack {
                Text("Connected:")
                Image(systemName: watchState.connected ? "bolt.fill" : "bolt.slash.fill")
                    .foregroundColor(watchState.connected ? .green : .red)
            }
           
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
        .navigationBarTitle(Text("⌚️ \(wrist.capitalized)"))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(wrist: "Right")
            .environmentObject(WatchState())
    }
}
#endif
