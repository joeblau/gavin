import XCTest
@testable import BlauProtocol

final class String_ExtensionsTests: XCTestCase {
    func testPasscodeGeneration() {
        String.generatePasscode().forEach { character in
            XCTAssertTrue(character.isNumber)
        }
    }
    
    func testDispatchData() {
        XCTAssertEqual("hello".dispatchData.count, 12)
    }
    
    static var allTests = [
        ("testPasscodeGeneration", testPasscodeGeneration),
    ]
}
