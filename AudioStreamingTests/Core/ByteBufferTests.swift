//
// Copyright © Blockchain Luxembourg S.A. All rights reserved.

import Testing
import Foundation
@testable import AudioStreaming

@Suite
struct ByteBufferTests {
    @Test
    func writeAndReadBytes() {
        var buffer = ByteBuffer(size: 10)

        // Write bytes to the buffer
        let testData = Data([0x01, 0x02, 0x03, 0x04])
        buffer.writeBytes(testData)
        buffer.rewind()

        do {
            // Read the written bytes
            let readData = try buffer.readBytes(4)
            #expect(readData == testData)
        } catch {
            Issue.record("Error reading bytes: \(error)")
        }
    }

    @Test
    func writeAndReadInteger() {
        var buffer = ByteBuffer(size: 8)

        // Write integer to the buffer
        let testInteger: UInt32 = 123_456_789
        buffer.put(testInteger)
        buffer.rewind()

        do {
            // Read the written integer
            let readInteger: UInt32 = try buffer.getInteger()
            #expect(readInteger == testInteger.bigEndian)
        } catch {
            Issue.record("Error reading integer: \(error)")
        }
    }

    @Test
    func writeAndReadFloat() {
        var buffer = ByteBuffer(size: 8)

        // Write float to the buffer
        let testFloat: Float = 123.456
        buffer.put(testFloat)
        buffer.rewind()

        do {
            // Read the written float
            let readFloat: Float = try buffer.getFloat()
            #expect(abs(readFloat - testFloat) < 0.001)
        } catch {
            Issue.record("Error reading float: \(error)")
        }
    }

    @Test
    func writeAndReadDouble() {
        var buffer = ByteBuffer(size: 8)

        // Write double to the buffer
        let testDouble = 123.456
        buffer.put(testDouble)
        buffer.rewind()

        do {
            // Read the written double
            let readDouble: Double = try buffer.getDouble()
            #expect(abs(readDouble - testDouble) < 0.001)
        } catch {
            Issue.record("Error reading double: \(error)")
        }
    }
}
