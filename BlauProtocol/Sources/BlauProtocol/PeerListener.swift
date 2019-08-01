//
//  PeerListener.swift
//  BlauProtocol
//
//  Created by Joe Blau on 6/30/19.
//

import Network
import os.log

class PeerListener {
    
    weak var delegate: PeerConnectionDelegate?
    var listener: NWListener?
    var name: String
    var passcode: String
    
    init(name: String,
         passcode: String,
         delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.name = name
        self.passcode = passcode
    }
    
    func startListtening() {
        do {
            let listener = try NWListener(using: NWParameters(passcode: passcode))
            self.listener = listener
            listener.service = NWListener.Service(name: self.name, type: "_blau._tcp")
            listener.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    os_log("listener ready on port %@", listener.port.debugDescription)
                case .failed(let error):
                    os_log("listener failed with %@, restarting", error.localizedDescription)
                    listener.cancel()
                    self.startListtening()
                default:
                    break
                }
            }
            
            listener.newConnectionHandler = { newConnection in
                if let delegate = self.delegate {
                    if sharedConnection == nil {
                        sharedConnection = PeerConnection(connection: newConnection,
                                                          delegate: delegate)
                    } else {
                        newConnection.cancel()
                    }
                }
            }
            
            listener.start(queue: .main)
        } catch {
            os_log("failed to craete listener: %@",
                   log: .default,
                   type: .error,
                   error.localizedDescription)
            abort()
        }
    }
    
    func reset(name: String) {
        self.name = name
        if let listener = listener {
            listener.service = NWListener.Service(name: self.name, type: "_blau._tcp")
        }
    }
}
