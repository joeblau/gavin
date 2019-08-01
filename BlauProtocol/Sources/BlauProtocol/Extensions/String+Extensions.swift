//
//  String+Extensions.swift
//  BlauProtocol
//
//  Created by Joe Blau on 7/6/19.
//

import Foundation

extension String {
    static func generatePasscode() -> String {
        return String("\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))")
    }
    
    var dispatchData: DispatchData {
        guard let stringData = self.data(using: .unicode) else {
            fatalError("can not unicode encode string into data")
        }
        return withUnsafeBytes(of: stringData) { ptr in
            DispatchData(bytes: UnsafeRawBufferPointer(start: ptr.baseAddress,
                                                       count: stringData.count))
        }
    }
}
