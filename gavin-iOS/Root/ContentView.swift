//
//  ContentView.swift
//  gavin-iOS
//
//  Created by Joe Blau on 7/31/19.
//

import SwiftUI

enum Tab {
    case run, tag, pair
}

struct ContentView: View {
    @State private var selection: Tab = .pair
    
    var body: some View {
        TabView(selection: $selection){
            Text("Run")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: selection == .run ? "g.circle.fill" : "g.circle")
                        Text("G.A.V.I.N.")
                    }
            }
            .tag(Tab.run)
            Text("Tag")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: selection == .tag ? "tag.fill" : "tag")
                        Text("Tag")
                    }
            }
            .tag(Tab.tag)
            PairView()
                .tabItem {
                    VStack {
                        Image(systemName: selection == .pair ? "plus.circle.fill" : "plus.circle")
                        Text("Pair")
                    }
            }
            .tag(Tab.pair)
                
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
