import XCTest
import Network
import CoreMotion

@testable import BlauProtocol

final class BlauProtocolTests: XCTestCase {
    var expect: XCTestExpectation?

    
    func testProtocolConnection() {
        expect = expectation(description: "test_connection")
        expect?.expectedFulfillmentCount = 4
        
//        sharedListener = PeerListener(name: "MockHost",
//                                      passcode: "0000",
//                                      delegate: self)
//        sharedBrowser = PeerBrowser(delegate: self)
//        }
//
//        let gyroData = CMGyroData()
//        watchAConnection?.sendGyroData(gyroData: gyroData)
        guard let expect = expect else {
            XCTFail()
            return
        }
        wait(for: [expect], timeout: 10)
    }
    
    
    
    static var allTests = [
        ("testProtocolConnection", testProtocolConnection),
    ]
}

extension BlauProtocolTests: PeerBrowserDelegate {
    func refresh(results: Set<NWBrowser.Result>) {
        guard let firstResult = results.first else {
            return
        }
        sharedConnection = PeerConnection(endpoint: firstResult.endpoint,
                                          interface: firstResult.interfaces.first,
                                          passcode: "0000",
                                          delegate: self)
    }
}

extension BlauProtocolTests: PeerConnectionDelegate {
    func connectionReady() {
        print("✅ connected")
        expect?.fulfill()
    }
    func connectionFailed() {
        print("🛑 failed")
    }
    func receiveMessage(context: Data?, message: NWProtocolFramer.Message) {
        print("message")
    }
}
