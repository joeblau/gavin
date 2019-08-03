//
//  PeerListener.swift
//  BlauProtocol
//
//  Created by Joe Blau on 6/30/19.
//

import Network
import os.log

public class PeerListener {
    
    weak var delegate: PeerConnectionDelegate?
    var listener: NWListener?
    public var peerConnection: PeerConnection?
    private var name: String
    private var passcode: String
    private var wristLocation: WristLocation
    
    public init(name: String,
         passcode: String,
         wristLocation: WristLocation,
         delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.name = name
        self.passcode = passcode
        self.wristLocation = wristLocation
        startListtening()
    }
    
    func startListtening() {
        do {
            let listener = try NWListener(using: NWParameters(passcode: passcode))
            self.listener = listener
            listener.service = NWListener.Service(name: self.name, type: "_blau_\(wristLocation)._tcp")
            listener.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    os_log("🛠 listener ready on port %@", listener.port.debugDescription)
                case .failed(let error):
                    os_log("🛠 listener failed with %@, restarting", error.localizedDescription)
                    listener.cancel()
                    self.startListtening()
                default:
                    break
                }
            }

            listener.newConnectionHandler = { newConnection in
                if let delegate = self.delegate {
                    if self.peerConnection == nil {
                        self.peerConnection = PeerConnection(connection: newConnection,
                                                          delegate: delegate)
                    } else {
                        newConnection.cancel()
                    }
                }
            }

            listener.start(queue: .main)
        } catch {
            os_log("🛠 failed to craete listener: %@",
                   error.localizedDescription)
            abort()
        }
    }
    
    public func reset(name: String) {
        self.name = name
        if let listener = listener {
            listener.service = NWListener.Service(name: self.name, type: "_blau_\(wristLocation)._tcp")
        }
    }
}
