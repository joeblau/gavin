//
//  DualWieldProtocol.swift
//  BlauProtocol
//
//  Created by Joe Blau on 7/1/19.
//

import Network
import Foundation
import os.log

public enum BlauMessageType: UInt32 {
    case invalid
    case deviceName
    case gyroSensor
}

class BlauProtocol: NWProtocolFramerImplementation {
    static let definition = NWProtocolFramer.Definition(implementation: BlauProtocol.self)
    static var label: String { "BlauProtocol" }
    
    required init(framer: NWProtocolFramer.Instance) {}
    
    func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult {
        return .ready
    }
    
    func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        while true {
            var tempHeader: BlauProtocolHeader? = nil
            let headerSize = BlauProtocolHeader.encodedSize
            let parsed = framer.parseInput(minimumIncompleteLength: headerSize,
                                           maximumLength: headerSize) { (buffer, isComplete) -> Int in
                    guard let buffer = buffer else {
                        return 0
                    }
                    if buffer.count < headerSize {
                        return 0
                    }
                    tempHeader = BlauProtocolHeader(buffer: buffer)
                    return headerSize
            }
            guard parsed, let header = tempHeader else {
                return headerSize
            }
            
            var messageType = BlauMessageType.invalid
            if let parsedMessageType = BlauMessageType(rawValue: header.type) {
                messageType = parsedMessageType
            }
            let message = NWProtocolFramer.Message(blauMessageType: messageType)
            
            if !framer.deliverInputNoCopy(length: Int(header.length),
                                          message: message,
                                          isComplete: true) {
                return 0
            }
        }
    }
    
    func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool) {
        let type = message.blauMessageType
        let header = BlauProtocolHeader(type: type.rawValue,
                                        length: UInt32(messageLength))
        framer.writeOutput(data: header.encodedData)
        
        do {
            try framer.writeOutputNoCopy(length: messageLength)
        } catch {
            os_log("🛠 hit error writing %@",
                   error.localizedDescription)
        }
    }
    
    func wakeup(framer: NWProtocolFramer.Instance) {}
    
    func stop(framer: NWProtocolFramer.Instance) -> Bool {
        return true
    }
    
    func cleanup(framer: NWProtocolFramer.Instance) {}
}
