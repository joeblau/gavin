//
//  PeerConnection.swift
//  BlauProtocol
//
//  Created by Joe Blau on 6/30/19.
//

import CoreMotion
import Foundation
import Network
import os.log

public var sharedConnection: PeerConnection?

public protocol PeerConnectionDelegate: class {
    func connectionReady()
    func connectionFailed()
    func receiveMessage(content: Data?, message: NWProtocolFramer.Message)
}

public class PeerConnection {
    weak var delegate: PeerConnectionDelegate?
    var connection: NWConnection?
    let instantiatedConnection: Bool
    
    public init(endpoint: NWEndpoint,
         interface: NWInterface?,
         passcode: String,
         delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.instantiatedConnection = true
        
        self.connection = NWConnection(to: endpoint,
                                       using: NWParameters(passcode: passcode))
        startConnection()
    }
    
    public init(connection: NWConnection,
         delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.connection = connection
        self.instantiatedConnection = false
        startConnection()
    }
    
    public func cancel() {
        if let connection = self.connection {
            connection.cancel()
            self.connection = nil
        }
    }
    
    func startConnection() {
        guard let connection = connection else {
            return
        }
        
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                os_log("🛠 %@ established", connection.debugDescription)
                self.receiveNextMessage()
                self.delegate?.connectionReady()
            case .failed(let error):
                os_log("🛠 %@ failed with error %@",
                       connection.debugDescription,
                       error.debugDescription)
                connection.cancel()
                self.delegate?.connectionFailed()
            default:
                break
            }
        }
        
        connection.start(queue: .main)
    }
    public func sendDeviceName(deviceName: String) {
        guard let connection = connection else {
            return
        }
        
        let message = NWProtocolFramer.Message(blauMessageType: .deviceName)
        let context = NWConnection.ContentContext(identifier: "DeviceName",
                                                  metadata: [message])
            
        connection.send(content: deviceName.data(using: .unicode),
                        contentContext: context,
                        isComplete: true,
                        completion: .idempotent)
    }
    
    public func sendGyroData(gyroscopeSensor: GyroscopeSensor) {
        guard let connection = connection else {
            return
        }
        
        let message = NWProtocolFramer.Message(blauMessageType: .gyroSensor)
        let context = NWConnection.ContentContext(identifier: "GyroSensor",
                                                  metadata: [message])
        
        let archivedGyroscopeSensor = try? NSKeyedArchiver.archivedData(withRootObject: gyroscopeSensor,
                                                                        requiringSecureCoding: true)
        
        connection.send(content: archivedGyroscopeSensor,
                        contentContext: context,
                        isComplete: true,
                        completion: .idempotent)
    }
    
    private func receiveNextMessage() {
        guard let connection = connection else {
            return
        }
        
        connection.receiveMessage { (content, context, isComplete, error) in
            if let blauMessage = context?.protocolMetadata(definition: BlauProtocol.definition) as? NWProtocolFramer.Message {
                self.delegate?.receiveMessage(content: content, message: blauMessage)
            }
            if error == nil {
                self.receiveNextMessage()
            }
        }
    }
}
