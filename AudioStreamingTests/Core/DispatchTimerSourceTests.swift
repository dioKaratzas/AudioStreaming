//
//  DispatchTimerSourceTests.swift
//  AudioStreamingTests
//
//  Created by Dimitrios Chatzieleftheriou on 25/10/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import Testing
import Foundation
@testable import AudioStreaming

@Suite
struct DispatchTimerSourceTests {
    let dispatchKey = DispatchSpecificKey<Int>()
    let dispatchQueue = DispatchQueue(label: "some.queue")

    var timerSource: DispatchTimerSource {
        DispatchTimerSource(interval: .milliseconds(100), queue: dispatchQueue)
    }

    init() {
        dispatchQueue.setSpecific(key: dispatchKey, value: 1)
    }

    @Test
    func dispatchTimerSourceCanBeActivatedAndSuspended() {
        // Create a new instance for this test
        let timerSource = self.timerSource

        // starts deactivated
        #expect(!timerSource.isRunning)

        // when actiavated
        timerSource.activate()
        // it should run
        #expect(timerSource.isRunning)

        // when suspended
        timerSource.suspend()
        // it should not run
        #expect(!timerSource.isRunning)
    }

    @available(iOS 16.0, *)
    @Test
    func dispatchTimerSourceCanAddAHandlerToBeCalled() async throws {
        var handlerCalled = false
        let timerSource = self.timerSource

        timerSource.add {
            handlerCalled = true
        }
        timerSource.activate()

        // Wait for handler to be called
        for _ in 0 ..< 10 {
            if handlerCalled {
                break
            }
            try await Task.sleep(for: .milliseconds(200))
        }

        #expect(handlerCalled)
        // kill the timer
        timerSource.suspend()
    }

    @available(iOS 16.0, *)
    @Test
    func dispatchTimerSourceCanRemoveHandler() async throws {
        var handlerCalled = false
        let timerSource = self.timerSource

        timerSource.add {
            handlerCalled = true
        }
        timerSource.activate()

        // Wait for handler to be called
        for _ in 0 ..< 10 {
            if handlerCalled {
                break
            }
            try await Task.sleep(for: .milliseconds(200))
        }

        #expect(handlerCalled)
        // kill the timer
        timerSource.suspend()
        timerSource.removeHandler()
    }

    @available(iOS 16.0, *)
    @Test
    func handlerIsExecutedOnTheSpecifiedQueue() async throws {
        var isOnCorrectQueue = false
        let timerSource = self.timerSource

        timerSource.add {
            isOnCorrectQueue = DispatchQueue.getSpecific(key: self.dispatchKey) == 1
        }
        timerSource.activate()

        // Wait for handler to be called
        for _ in 0 ..< 10 {
            if isOnCorrectQueue {
                break
            }
            try await Task.sleep(for: .milliseconds(200))
        }

        #expect(isOnCorrectQueue)
        // kill the timer
        timerSource.suspend()
    }
}
