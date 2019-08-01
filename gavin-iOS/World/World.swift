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
    var listener: PeerListener?
}

var Current = World()
