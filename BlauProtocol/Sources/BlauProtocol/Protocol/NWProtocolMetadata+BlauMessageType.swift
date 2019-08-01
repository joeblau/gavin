//
//  NWProtocolMetadata+BlauMessageType.swift
//  BlauProtocol
//
//  Created by Joe Blau on 7/6/19.
//

import Network

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
