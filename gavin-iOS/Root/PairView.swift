//
//  PairView.swift
//  gavin-iOS
//
//  Created by Joe Blau on 8/1/19.
//

import SwiftUI

struct PairView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Passcode: \(Current.passcode)")
                Text("Left ⌚️: ")
                Text("Right ⌚️: ")
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
