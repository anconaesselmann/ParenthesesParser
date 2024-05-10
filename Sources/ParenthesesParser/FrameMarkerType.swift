//  Created by Axel Ancona Esselmann on 5/10/24.
//

import Foundation

internal enum FrameMarkerType: Hashable, Equatable {
    case start(Character), end(Character)

    var isStart: Bool {
        if case .start = self { return true }
        else { return false }
    }

    var value: Character {
        switch self {
        case .start(let value), .end(let value): return value
        }
    }
}
