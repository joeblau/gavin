//
//  PairView.swift
//  gavin-iOS
//
//  Created by Joe Blau on 8/1/19.
//

import SwiftUI

struct PairView: View {
    @State private var leftConnected: Bool = false
    @State private var rightConnected: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Passcode: \(Current.passcode)")
                Text("Left ⌚️: \(leftConnected.description)")
                Text("Right ⌚️: \(rightConnected.description)")
            }
            .navigationBarTitle(Text("Pair"))
        }
    }
}

#if DEBUG
struct PairView_Previews: PreviewProvider {
    static var previews: some View {
        PairView()
    }
}
#endif
