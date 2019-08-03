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

class HostingController: WKHostingController<ContentView> {
    
    override init() {
        super.init()
        Current.browser = PeerBrowser(delegate: self)
    }
    
    override var body: ContentView {
        
        return ContentView(wrist: WKInterfaceDevice
            .current()
            .wristLocation
            .description)
    }
}

extension HostingController: PeerBrowserDelegate {
    func refresh(results: Set<NWBrowser.Result>) {
        // reload list or hosts
        guard let firstResult = results.first else {
            return
        }
        sharedConnection = PeerConnection(endpoint: firstResult.endpoint,
                                          interface: firstResult.interfaces.first,
                                          passcode: "0000",
                                          delegate: self)
        
        
    }
}

extension HostingController: PeerConnectionDelegate {
    func connectionReady() {
        
        print("✅ connected")
        sharedConnection?.sendDeviceName(deviceName: "hey")
//        let gyroData = CMGyroData()
//        let gs = GyroscopeSensor(wrist: .left, gyroData: gyroData)
//        sharedConnection?.sendGyroData(gyroscopeSensor: gs)
    }
    func connectionFailed() {
        print("🛑 failed")
    }
    func receiveMessage(content: Data?, message: NWProtocolFramer.Message) {
        print("message")
    }
}
