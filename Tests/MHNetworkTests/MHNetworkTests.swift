import XCTest
@testable import MHNetwork

final class MHNetworkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MHNetwork().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
