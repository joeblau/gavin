//
//  BlauProtocolHeader.swift
//  BlauProtocol
//
//  Created by Joe Blau on 7/6/19.
//

import Foundation

struct BlauProtocolHeader: Codable {
    static var encodedSize: Int = MemoryLayout<UInt32>.size * 2
    
    let type: UInt32
    let length: UInt32
    
    init(type: UInt32, length: UInt32) {
        self.type = type
        self.length = length
    }
    
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
