//
//  HostingController.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 7/31/19.
//

import WatchKit
import Foundation
import SwiftUI
import BlauProtocol
import Network
import CoreMotion

class HostingController: WKHostingController<AnyView> {
    private let watchState = WatchState()
    
    override init() {
        super.init()
        Current.browser = PeerBrowser(wristLocation: WKInterfaceDevice.current().wrist, delegate: self)
    }
    
    override var body: AnyView {
        return AnyView(ContentView(wrist: WKInterfaceDevice.current().wrist.description)
            .environmentObject(watchState))
    }
}

extension HostingController: PeerBrowserDelegate {
    func refresh(results: Set<NWBrowser.Result>) {
        guard let firstResult = results.first else {
            return
        }
        Current.peerConnection = PeerConnection(endpoint: firstResult.endpoint,
                                          interface: firstResult.interfaces.first,
                                          passcode: "0000",
                                          delegate: self)
    }
}

extension HostingController: PeerConnectionDelegate {
    func connectionReady() {
        
        watchState.connected = true
        Current.peerConnection?.send(deviceName: WKInterfaceDevice.current().name)
    }
    func connectionFailed() {
        watchState.connected = false

        print("🛑 failed")
    }
    func receiveMessage(content: Data?, message: NWProtocolFramer.Message) {
        print("message")
    }
}
