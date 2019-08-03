//
//  World.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 8/1/19.
//

import Foundation
import BlauProtocol
import Combine
import SwiftUI

struct World {
    var browser: PeerBrowser?
    var peerConnection: PeerConnection?
}

var Current = World()

final class WatchState: ObservableObject {
    @Published var connected = false
}
