//  Created by Axel Ancona Esselmann on 5/10/24.
//

import Foundation

public struct Frame {
    public let frameType: FrameType
    public let start: String.Index
    public let end: String.Index
    public let subFrames: [Frame]
}
