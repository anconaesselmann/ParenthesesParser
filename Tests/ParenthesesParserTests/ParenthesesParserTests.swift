import XCTest
@testable import ParenthesesParser

final class MatcherTests: XCTestCase {

    var sut: ParenthesesParser! = ParenthesesParser()

    override func setUp()  {
        sut = ParenthesesParser()
    }

    override func tearDown() {
        sut = nil
    }

    func testEmptyContent() throws {
        let content = "()"
        let frame = try sut.parse(content)
        XCTAssertEqual(frame.frameType, .parentheses)
        XCTAssertEqual(frame.start, content.startIndex)
        XCTAssertEqual(frame.end, content.endIndex)
    }

    func testCreatesRootFrame() throws {
        let content = "(a + b)"
        let frame = try sut.parse(content)
        XCTAssertEqual(frame.frameType, .parentheses)
        XCTAssertEqual(frame.start, content.startIndex)
        XCTAssertEqual(frame.end, content.endIndex)
    }

    func testOneSubframeInRoot() throws {
        let content = "(a + (b - c) * d)"
        let root = try sut.parse(content)

        XCTAssertEqual(root.frameType, .parentheses)
        XCTAssertEqual(root.start, content.startIndex)
        XCTAssertEqual(root.end, content.endIndex)

        let subFrames = root.subFrames

        XCTAssertEqual(subFrames.count, 1)
        let subFrame = subFrames[0]

        XCTAssertEqual(subFrame.frameType, .parentheses)
        XCTAssertEqual(subFrame.start, content.index(content.startIndex, offsetBy: 5))
        XCTAssertEqual(subFrame.end, content.index(content.startIndex, offsetBy: 12))
    }

    func testTwoSubframesInRoot() throws {
        let content = "(a + (b - c) * (d - e))"
        let root = try sut.parse(content)

        XCTAssertEqual(root.frameType, .parentheses)
        XCTAssertEqual(root.start, content.startIndex)
        XCTAssertEqual(root.end, content.endIndex)

        let subFrames = root.subFrames

        XCTAssertEqual(subFrames.count, 2)
        let firstSubFrame = subFrames[0]

        XCTAssertEqual(firstSubFrame.frameType, .parentheses)
        XCTAssertEqual(firstSubFrame.start, content.index(content.startIndex, offsetBy: 5))
        XCTAssertEqual(firstSubFrame.end, content.index(content.startIndex, offsetBy: 12))

        let secondSubFrame = subFrames[1]

        XCTAssertEqual(secondSubFrame.frameType, .parentheses)
        XCTAssertEqual(secondSubFrame.start, content.index(content.startIndex, offsetBy: 15))
        XCTAssertEqual(secondSubFrame.end, content.index(content.startIndex, offsetBy: 22))
    }

    func testMultipleFrameTypes() throws {
        let content = "(a + [b - {c * d} - e])"
        let root = try sut.parse(content, types: [.parentheses, .braces, .brackets])

        XCTAssertEqual(root.frameType, .parentheses)
        XCTAssertEqual(root.start, content.startIndex)
        XCTAssertEqual(root.end, content.endIndex)

        let levelOneSubFrames = root.subFrames
        XCTAssertEqual(levelOneSubFrames.count, 1)
        let levelOneSubFrame = levelOneSubFrames[0]

        XCTAssertEqual(levelOneSubFrame.frameType, .brackets)
        XCTAssertEqual(levelOneSubFrame.start, content.index(content.startIndex, offsetBy: 5))
        XCTAssertEqual(levelOneSubFrame.end, content.index(content.startIndex, offsetBy: 22))

        let levelTwoSubFrames = levelOneSubFrame.subFrames
        XCTAssertEqual(levelTwoSubFrames.count, 1)
        let levelTwoSubFrame = levelTwoSubFrames[0]

        XCTAssertEqual(levelTwoSubFrame.frameType, .braces)
        XCTAssertEqual(levelTwoSubFrame.start, content.index(content.startIndex, offsetBy: 10))
        XCTAssertEqual(levelTwoSubFrame.end, content.index(content.startIndex, offsetBy: 17))
    }
}
