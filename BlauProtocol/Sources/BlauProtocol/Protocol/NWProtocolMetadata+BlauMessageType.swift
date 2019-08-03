//
//  NWProtocolMetadata+BlauMessageType.swift
//  BlauProtocol
//
//  Created by Joe Blau on 7/6/19.
//

import Network

public extension NWProtocolFramer.Message {
    convenience init(blauMessageType: BlauMessageType) {
        self.init(definition: BlauProtocol.definition)
        self.blauMessageType = blauMessageType
    }
    
    var blauMessageType: BlauMessageType {
        get {
            return self["BlauMessageType"] as? BlauMessageType ?? .invalid
        }
        set {
            self["BlauMessageType"] = newValue
        }
    }
}
