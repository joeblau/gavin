//
//  World.swift
//  gavin-iOS
//
//  Created by Joe Blau on 8/1/19.
//

import Foundation
import BlauProtocol

struct World {
    var passcode = "0000"
    var leftWatchListener: PeerListener?
    var rightWatchListener: PeerListener?
}

var Current = World()


final class PhoneState: ObservableObject {
    @Published var leftWatchConnected = false
    @Published var rightWatchConnected = false
}
