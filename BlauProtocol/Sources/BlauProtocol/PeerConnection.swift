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

var sharedConnection: PeerConnection?

protocol PeerConnectionDelegate: class {
    func connectionReady()
    func connectionFailed()
    func receiveMessage(context: Data?, message: NWProtocolFramer.Message)
}

class PeerConnection {
    weak var delegate: PeerConnectionDelegate?
    var connection: NWConnection?
    let instantiatedConnection: Bool
    
    init(endpoint: NWEndpoint,
         interface: NWInterface?,
         passcode: String,
         delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.instantiatedConnection = true
        
        self.connection = NWConnection(to: endpoint,
                                       using: NWParameters(passcode: passcode))
        startConnection()
    }
    
    init(connection: NWConnection,
         delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.connection = connection
        self.instantiatedConnection = false
        startConnection()
    }
    
    func cancel() {
        if let connection = self.connection {
            connection.cancel()
            self.connection = nil
        }
    }
    
    private func startConnection() {
        guard let connection = connection else {
            return
        }
        
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                os_log("%@ established", connection.debugDescription)
                self.receiveNextMessage()
                
                if let delegate = self.delegate {
                    delegate.connectionReady()
                }
            case .failed(let error):
                os_log("%@ failed with error %@",
                       connection.debugDescription,
                       error.debugDescription)
                connection.cancel()
                if let delegate = self.delegate {
                    delegate.connectionFailed()
                }
            default:
                break
            }
        }
    }
    
    func sendGyroData(_ gyroData: CMGyroData) {
        guard let connection = connection else {
            return
        }
        
        let message = NWProtocolFramer.Message(blauMessageType: .gyro)
        let context = NWConnection.ContentContext(identifier: "gyro",
                                                  metadata: [message])
        
        let archivedGyroData = try? NSKeyedArchiver.archivedData(withRootObject: gyroData, requiringSecureCoding: true)
        
        connection.send(content: archivedGyroData,
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
                self.delegate?.receiveMessage(context: content, message: blauMessage)
            }
            if error == nil {
                self.receiveNextMessage()
            }
        }
    }
}
