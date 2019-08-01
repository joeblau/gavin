//
//  BlauProtocol.swift
//  BlauProtocol
//
//  Created by Joe Blau on 7/1/19.
//

import Network
import Foundation

enum BlaudMessageType: UInt32 {
    case invalid
    case gyro
}

class BlauProtocol: NWProtocolFramerImplementation {
    static let definition = NWProtocolFramer.Definition(implementation: BlauProtocol.self)
    static var label: String { "Blau" }
    
    required init(framer: NWProtocolFramer.Instance) {}
    
    func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult {
        return .ready
    }
    
    func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        // TODO
        return 0
    }
    
    func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool) {
        // TODO
    }
    
    func wakeup(framer: NWProtocolFramer.Instance) {}
    
    func stop(framer: NWProtocolFramer.Instance) -> Bool {
        return true
    }
    
    func cleanup(framer: NWProtocolFramer.Instance) {}
}

extension NWProtocolFramer.Message {
    convenience init(blauMessageType: BlaudMessageType) {
        self.init(definition: BlauProtocol.definition)
        self.blauMessageType = blauMessageType
    }
    
    var blauMessageType: BlaudMessageType {
        get {
            return self["BlaudMessageType"] as? BlaudMessageType ?? .invalid
        }
        set {
            self["BlauMessageType"] = newValue
        }
    }
}

struct BlauProtocolHeader: Codable {
    static var encodedSize: Int = MemoryLayout<UInt32>.size * 2
    
    let type: UInt32
    let length: UInt32
    
    init(buffer: UnsafeMutableRawBufferPointer) {
        var tempType: UInt32 = 0
        var tempLength: UInt32 = 0
        withUnsafeMutableBytes(of: &tempType) { typePtr in
            typePtr.copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!.advanced(by: 0),
                                                            count: MemoryLayout<UInt32>.size))
        }
        withUnsafeMutableBytes(of: &tempLength) { lengthPtr in
            lengthPtr.copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!.advanced(by: MemoryLayout<UInt32>.size),
                                                              count: MemoryLayout<UInt32>.size))
        }
        type = tempType
        length = tempLength
    }
    
    var encodedData: Data {
        var tempType = type
        var tempLength = length
        var data = Data(bytes: &tempType, count: MemoryLayout<UInt32>.size)
        data.append(Data(bytes: &tempLength, count: MemoryLayout<UInt32>.size))
        return data
    }
}
