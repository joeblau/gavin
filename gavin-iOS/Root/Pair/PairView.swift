//
//  PairView.swift
//  gavin-iOS
//
//  Created by Joe Blau on 8/1/19.
//

import SwiftUI

struct PairView: View {
    @EnvironmentObject var phoneState: PhoneState
    @State private var leftConnected: Bool = false
    @State private var rightConnected: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Passcode: \(Current.passcode)")
                Text("Left ⌚️: \(phoneState.leftWatchConnected.description)")
                Text("Right ⌚️: \(phoneState.rightWatchConnected.description)")
            }
            .navigationBarTitle(Text("Pair"))
        }
    }
}

#if DEBUG
struct PairView_Previews: PreviewProvider {
    static var previews: some View {
        PairView().environmentObject(PhoneState())
    }
}
#endif
