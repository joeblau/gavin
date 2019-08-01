//
//  ContentView.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 7/31/19.
//

import SwiftUI

struct ContentView: View {
    var wrist: String
    
    var body: some View {
        VStack {
            Text("Wrist \(wrist)")
            Button(action: {}) {Text("Start")}
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
