//  Created by Axel Ancona Esselmann on 5/10/24.
//

import Foundation

public class ParenthesesParser {

    public enum Error: Swift.Error {
        case emptyFrameTypeArray
        case emptyFrame
        case invalidFrameStart
        case imbalancedFrames
        case foundFrameEndWithoutMatchingFrameStart
        case foundFrameStartWithoutMatchingFrameStart
        case noFrame
    }

    private var frameTypes: [FrameType] = []
    private var frameMarkerTypes: [FrameMarkerType] = []
    private var content: any StringProtocol = ""

    public init() { }

    public func nextFrame(_ content: any StringProtocol, from index: String.Index, types frameTypes: [FrameType] = [.parentheses]) throws -> Frame {
        self.frameTypes = frameTypes
        self.frameMarkerTypes = frameTypes.flatMap { [$0.startMarkerType, $0.endMarkerType] }
        self.content = content
        guard let frameStart = nextFrameMarker(from: index) else {
            throw Error.noFrame
        }
        return try parse(from: frameStart.index)
    }

    public func parse(_ content: any StringProtocol, types frameTypes: [FrameType] = [.parentheses]) throws -> Frame {
        self.frameTypes = frameTypes
        self.frameMarkerTypes = frameTypes.flatMap { [$0.startMarkerType, $0.endMarkerType] }
        self.content = content
        return try parse(from: content.startIndex)
    }

    private func parse(from index: String.Index) throws -> Frame {
        guard !frameTypes.isEmpty else {
            throw Error.emptyFrameTypeArray
        }
        guard index < content.endIndex else {
            throw Error.emptyFrame
        }
        let firstCharacter = content[index]
        guard let frameType = frameTypes.first(where: { $0.startMarkerType.value == firstCharacter }) else {
            throw Error.invalidFrameStart
        }
        let frameEnd = frameType.endMarkerType

        var currentIndex = content.index(after: index)
        var subFrames: [Frame] = []
        while currentIndex < content.endIndex {
            guard let nextFrameMarker = nextFrameMarker(from: currentIndex) else {
                throw Error.imbalancedFrames
            }
            currentIndex = nextFrameMarker.index
            if nextFrameMarker.markerType == frameEnd {
                return Frame(
                    frameType: frameType,
                    start: index,
                    end: content.index(after: currentIndex),
                    subFrames: subFrames
                )
            }
            guard nextFrameMarker.markerType.isStart else {
                throw Error.foundFrameEndWithoutMatchingFrameStart
            }
            let subFrame = try parse(from: currentIndex)
            subFrames.append(subFrame)
            currentIndex = subFrame.end
        }
        throw Error.foundFrameStartWithoutMatchingFrameStart
    }

    private func nextFrameMarker(from index: String.Index) -> FrameMarker? {
        var current = index
        while current < content.endIndex {
            if let match = frameMarkerTypes.first(where: {
                $0.value == self.content[current]
            }) {
                return FrameMarker(markerType: match, index: current)
            }
            current = content.index(after: current)
        }
        return nil
    }
}
