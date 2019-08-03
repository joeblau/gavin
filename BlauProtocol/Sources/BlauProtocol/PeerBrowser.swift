//
//  PeerBrowser.swift
//  BlauProtocol
//
//  Created by Joe Blau on 6/30/19.
//

import Network
import os.log

public protocol PeerBrowserDelegate: class {
    func refresh(results: Set<NWBrowser.Result>)
}

public class PeerBrowser {
    private weak var delegate: PeerBrowserDelegate?
    private var browser: NWBrowser?
    private var wristLocation: WristLocation

    public init(wristLocation: WristLocation,
                delegate: PeerBrowserDelegate) {
        self.delegate = delegate
        self.wristLocation = wristLocation

        startBrowsing()
    }
    
    public func startBrowsing()  {
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        let browser = NWBrowser(for: .bonjour(type: "_blau_\(wristLocation)._tcp", domain: nil),
                                using: parameters)
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                os_log("🛠 %@",
                       error.localizedDescription)
                browser.cancel()
                self.startBrowsing()
            default:
                break
            }
        }
        
        browser.browseResultsChangedHandler = { results, changes in
            self.delegate?.refresh(results: results)
        }
        
        browser.start(queue: .main)
    }
}
