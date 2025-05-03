//
//  Created by Dimitrios Chatzieleftheriou on 22/05/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import Testing
import Foundation
@testable import AudioStreaming

@Suite
struct AtomicTests {
    @Test
    func protectedValuesAreAccessedSafely() {
        let atomic = Atomic<Int>(0)

        DispatchQueue.concurrentPerform(iterations: 100_000) { _ in
            _ = atomic.value
            atomic.write { $0 += 1 }
        }

        #expect(atomic.value == 100_000)
    }

    @Test
    func thatProtectedReadAndWriteAreSafe() {
        let initialValue = "aValue"
        let protected = Atomic<String>(initialValue)

        DispatchQueue.concurrentPerform(iterations: 1000) { i in
            _ = protected.value
            protected.write { $0 = "\(i)" }
        }

        #expect(protected.value != initialValue)
    }
}
