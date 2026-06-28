import XCTest
@testable import MoonloomApp

final class NumberAbbreviatorTests: XCTestCase {

    private let formatter = NumberAbbreviator()

    /// Acceptance criteria from MOONLOOM-PROMPT-001.
    func testCanonicalThresholds() {
        XCTAssertEqual(formatter.string(from: 1_000), "1K")
        XCTAssertEqual(formatter.string(from: 1_000_000), "1M")
        XCTAssertEqual(formatter.string(from: 1_000_000_000_000), "1T")
    }

    func testBillions() {
        XCTAssertEqual(formatter.string(from: 1_000_000_000), "1B")
    }

    func testFractionalAbbreviation() {
        XCTAssertEqual(formatter.string(from: 1_234), "1.23K")
        XCTAssertEqual(formatter.string(from: 1_500_000), "1.5M")
        XCTAssertEqual(formatter.string(from: 2_500), "2.5K")
    }

    func testSmallNumbers() {
        XCTAssertEqual(formatter.string(from: 0), "0")
        XCTAssertEqual(formatter.string(from: 999), "999")
        XCTAssertEqual(formatter.string(from: 42), "42")
    }

    func testSubOneValuesKeepPrecision() {
        XCTAssertEqual(formatter.string(from: 0.1), "0.1")
    }

    func testHigherTierSuffixes() {
        XCTAssertEqual(formatter.string(from: 1e15), "1Qa")
        XCTAssertEqual(formatter.string(from: 1e18), "1Qi")
    }

    func testRolloverDoesNotProduce1000K() {
        // 999_999 must not render as "1000K".
        XCTAssertEqual(formatter.string(from: 999_999), "1M")
    }

    func testNegativeValues() {
        XCTAssertEqual(formatter.string(from: -1_000), "-1K")
    }

    func testVeryLargeFallsBackToScientific() {
        // Beyond the named suffix table (10^33), expect scientific notation.
        let result = formatter.string(from: 1e40)
        XCTAssertTrue(result.contains("e"), "Expected scientific notation, got \(result)")
    }
}
