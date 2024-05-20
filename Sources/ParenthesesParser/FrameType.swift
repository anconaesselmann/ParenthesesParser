//  Created by Axel Ancona Esselmann on 5/10/24.
//

import Foundation

public struct FrameType: Equatable {

    public static var parentheses: Self { .init(start: "(", end: ")") }
    public static var brackets: Self { .init(start: "[", end: "]") }
    public static var braces: Self { .init(start: "{", end: "}") }

    public let start: Character
    public let end: Character

    var startMarkerType: FrameMarkerType { .start(start) }
    var endMarkerType: FrameMarkerType { .end(end) }

    public init(start: Character, end: Character) {
        self.start = start
        self.end = end
    }
}

public extension FrameType {
    init?(start: Character) {
        switch start {
        case "{":
            self = .braces
        case "(":
            self = .parentheses
        case "[":
            self = .brackets
        default:
            return nil
        }
    }

    var isBraces: Bool {
        self == .braces
    }

    var isParentheses: Bool {
        self == .parentheses
    }

    var isBrackets: Bool {
        self == .brackets
    }
}
