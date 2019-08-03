//
//  SceneDelegate.swift
//  gavin-iOS
//
//  Created by Joe Blau on 7/31/19.
//

import UIKit
import SwiftUI
import Network
import BlauProtocol

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        sharedConnection?.cancel()
        Current.listener = PeerListener(name: UIDevice.current.name,
                                        passcode: Current.passcode,
                                        delegate: self)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: ContentView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    
}

extension SceneDelegate: PeerConnectionDelegate {
    func connectionReady() {
        print("ready")
    }
    
    func connectionFailed() {
        print("failed")
    }
    
    func receiveMessage(content: Data?, message: NWProtocolFramer.Message) {
        guard let content = content else {
            return
        }
        switch message.blauMessageType {
        case .invalid:
            print("Received invalid message")
        case .deviceName:
            handleDeviceName(content, message)
        case .gyroSensor:
            handleGyroSensor(content, message)
        }
    }
    
    func handleDeviceName(_ content: Data, _ message: NWProtocolFramer.Message) {
        print("device name")
    }
    
    func handleGyroSensor(_ content: Data, _ message: NWProtocolFramer.Message) {
        print("gyro sensor")
    }
    
    
}
