//
//  Created by Dimitrios Chatzieleftheriou on 04/06/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import Testing
import AVFoundation
@testable import AudioStreaming

@Suite
struct PlayerQueueEntriesTests {
    @Test
    func playerQueueEntriesInitsEmpty() {
        let queue = PlayerQueueEntries()

        #expect(queue.isEmpty)
        #expect(queue.isEmpty)
        #expect(queue.count(for: .buffering) == 0)
        #expect(queue.count(for: .upcoming) == 0)
    }

    @Test
    func playerQueueCanEnqueueAndDequeueOnCorrectType() {
        // given
        let queue = PlayerQueueEntries()
        let firstEntry = audioEntry(id: "1")

        // when
        queue.enqueue(item: firstEntry, type: .upcoming)
        let entry = queue.dequeue(type: .upcoming)
        let entry1 = queue.dequeue(type: .buffering)

        // then
        #expect(entry != nil)
        #expect(entry1 == nil)
        #expect(firstEntry == entry)
    }

    @Test
    func playerQueueCanEnqueueAndDequeue() {
        // given
        let queue = PlayerQueueEntries()
        let firstEntry = audioEntry(id: "1")
        let secondEntry = audioEntry(id: "2")

        // when
        queue.enqueue(item: firstEntry, type: .upcoming)
        queue.enqueue(item: secondEntry, type: .buffering)
        let entry = queue.dequeue(type: .upcoming)
        let entry1 = queue.dequeue(type: .buffering)

        // then
        #expect(entry != nil)
        #expect(entry1 != nil)
        #expect(firstEntry == entry)
    }

    @Test
    func playerQueueCanOutputPendingAudioEntryIds() {
        // given
        let queue = PlayerQueueEntries()
        let firstEntry = audioEntry(id: "1")
        let secondEntry = audioEntry(id: "2")

        // when
        queue.enqueue(item: firstEntry, type: .upcoming)
        queue.enqueue(item: secondEntry, type: .buffering)

        // then
        let expected = [firstEntry.id, secondEntry.id]
        let entries = queue.pendingEntriesId()
        #expect(!entries.isEmpty)
        #expect(entries == expected)
    }

    @Test
    func playerQueueEntriesCanSkipQueues() {
        let queue = PlayerQueueEntries()

        let firstEntry = audioEntry(id: "1")
        let secondEntry = audioEntry(id: "2")
        let batchEntries = [audioEntry(id: "3"), audioEntry(id: "4")]

        queue.enqueue(item: firstEntry, type: .buffering)
        queue.skip(item: secondEntry, type: .buffering)

        let entry = queue.dequeue(type: .buffering)
        #expect(entry == secondEntry)

        queue.skip(items: batchEntries, type: .buffering)
        let entry1 = queue.dequeue(type: .buffering)
        #expect(entry1 == batchEntries.last!)
    }

    @Test
    func playerQueueCountReturnsCorrectValue() {
        let queue = PlayerQueueEntries()

        queue.enqueue(item: audioEntry(id: "1"), type: .buffering)
        #expect(queue.count == 1)
        #expect(queue.count(for: .buffering) == 1)
        #expect(queue.count(for: .upcoming) == 0)

        queue.enqueue(item: audioEntry(id: "2"), type: .upcoming)
        #expect(queue.count == 2)
        #expect(queue.count(for: .buffering) == 1)
        #expect(queue.count(for: .upcoming) == 1)

        queue.enqueue(item: audioEntry(id: "3"), type: .buffering)
        #expect(queue.count == 3)
        #expect(queue.count(for: .buffering) == 2)
        #expect(queue.count(for: .upcoming) == 1)

        queue.enqueue(item: audioEntry(id: "4"), type: .upcoming)
        #expect(queue.count == 4)
        #expect(queue.count(for: .buffering) == 2)
        #expect(queue.count(for: .upcoming) == 2)

        _ = queue.dequeue(type: .upcoming)
        #expect(queue.count == 3)
        #expect(queue.count(for: .buffering) == 2)
        #expect(queue.count(for: .upcoming) == 1)
    }

    @Test
    func playerQueueCanRemoveAllElemenets() {
        let queue = PlayerQueueEntries()

        for i in 0 ..< 10 {
            queue.enqueue(item: audioEntry(id: "\(i)"), type: .buffering)
            queue.enqueue(item: audioEntry(id: "\(i)"), type: .upcoming)
        }

        queue.removeAll(for: .buffering)
        #expect(queue.count(for: .buffering) == 0)
        #expect(queue.count(for: .upcoming) == 10)

        queue.removeAll(for: .upcoming)
        #expect(queue.count(for: .upcoming) == 0)
    }

    @Test
    func playerQueueThreadSafety() {
        var queue = PlayerQueueEntries()

        DispatchQueue.concurrentPerform(iterations: 100) { i in
            queue.enqueue(item: audioEntry(id: "\(i))"), type: .buffering)
            queue.enqueue(item: audioEntry(id: "\(i))"), type: .upcoming)
            _ = queue.dequeue(type: .buffering)
            _ = queue.dequeue(type: .upcoming)
        }

        #expect(queue.isEmpty)

        queue = PlayerQueueEntries()

        DispatchQueue.concurrentPerform(iterations: 100) { i in
            let entry = audioEntry(id: "\(i))")
            queue.enqueue(item: entry, type: .buffering)
            _ = queue.count(for: .buffering)
        }

        #expect(queue.count(for: .buffering) == 100)

        queue = PlayerQueueEntries()

        DispatchQueue.concurrentPerform(iterations: 100) { i in
            let entry = audioEntry(id: "\(i))")
            queue.enqueue(item: entry, type: .buffering)
            _ = queue.pendingEntriesId()
        }

        #expect(queue.pendingEntriesId().count == 100)
    }
}

private let networkingClient = NetworkingClient(configuration: .ephemeral)
private func audioEntry(id: String) -> AudioEntry {
    let source =
        RemoteAudioSource(
            networking: networkingClient,
            url: URL(string: "www.a-url.com")!,
            underlyingQueue: DispatchQueue(label: "some-queue"),
            httpHeaders: [:]
        )
    let outputFormat = AVAudioFormat()
    return AudioEntry(source: source, entryId: AudioEntryId(id: id), outputAudioFormat: outputFormat)
}
