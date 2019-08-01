//
//  NWParameters+Extension.swift
//  BlauProtocol
//
//  Created by Joe Blau on 7/1/19.
//

import Network
import CryptoKit

extension NWParameters {
    convenience init(passcode: String) {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.enableFastOpen = true
        tcpOptions.keepaliveIdle = 2
        
        self.init(tls: NWParameters.tlsOptoins(passcode: passcode), tcp: tcpOptions)
        
        includePeerToPeer = true
        
        let dualWieldOptions = NWProtocolFramer.Options(definition: BlauProtocol.definition)
        self.defaultProtocolStack.applicationProtocols.insert(dualWieldOptions, at: 0)
    }
    
    private static func tlsOptoins(passcode: String) -> NWProtocolTLS.Options {
        guard let passcodeData =  passcode.data(using: .utf8),
            let protocolData = BlauProtocol.label.data(using: .utf8) else {
                fatalError("can not utf8 encode string into data")
        }
        
        let authenticationKey = SymmetricKey(data:passcodeData)
        var authenticationCode = HMAC<SHA256>.authenticationCode(for: protocolData, using: authenticationKey)
        let authenticationDispatchData = withUnsafeBytes(of: &authenticationCode) { ptr in
            DispatchData(bytes: ptr)
        }
        
        let tlsOptions = NWProtocolTLS.Options()
        sec_protocol_options_add_pre_shared_key(tlsOptions.securityProtocolOptions,
                                                authenticationDispatchData as __DispatchData,
                                                BlauProtocol.label.dispatchData as __DispatchData)
        sec_protocol_options_append_tls_ciphersuite(tlsOptions.securityProtocolOptions,
                                                    tls_ciphersuite_t(rawValue: TLS_PSK_WITH_AES_128_GCM_SHA256)!)
        return tlsOptions
    }
}

extension String {
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
