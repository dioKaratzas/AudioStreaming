//
//  AudioSessionManagerTests.swift
//  AudioStreamingTests
//
//  Created by Dionisis Karatzas.
//  Copyright © 2025 Dionisis Karatzas. All rights reserved.
//

#if !os(macOS)
    import XCTest
    import AVFoundation
    @testable import AudioStreaming

    final class AudioSessionManagerTests: XCTestCase, AudioSessionInterruptionDelegate {
        var audioSessionManager: AudioSessionManager!
        var interruptionExpectation: XCTestExpectation?
        var routeChangeExpectation: XCTestExpectation?

        var lastInterruptionType: AVAudioSession.InterruptionType?
        var lastInterruptionOptions: AVAudioSession.InterruptionOptions?
        var lastRouteChangeReason: AVAudioSession.RouteChangeReason?

        override func setUp() {
            super.setUp()
            audioSessionManager = AudioSessionManager.shared
            audioSessionManager.interruptionDelegate = self
        }

        override func tearDown() {
            audioSessionManager.interruptionDelegate = nil
            interruptionExpectation = nil
            routeChangeExpectation = nil
            lastInterruptionType = nil
            lastInterruptionOptions = nil
            lastRouteChangeReason = nil
            super.tearDown()
        }

        func testInterruptionHandling() {
            // Given
            interruptionExpectation = expectation(description: "Should receive interruption callback")

            // When
            NotificationCenter.default.post(
                name: AVAudioSession.interruptionNotification,
                object: nil,
                userInfo: [
                    AVAudioSessionInterruptionTypeKey: AVAudioSession.InterruptionType.began.rawValue,
                    AVAudioSessionInterruptionOptionKey: AVAudioSession.InterruptionOptions.shouldResume.rawValue
                ]
            )

            // Then
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertEqual(lastInterruptionType, .began)
            XCTAssertEqual(lastInterruptionOptions, .shouldResume)
        }

        func testRouteChangeHandling() {
            // Given
            routeChangeExpectation = expectation(description: "Should receive route change callback")

            // When
            NotificationCenter.default.post(
                name: AVAudioSession.routeChangeNotification,
                object: nil,
                userInfo: [
                    AVAudioSessionRouteChangeReasonKey: AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue,
                    AVAudioSessionRouteChangePreviousRouteKey: AVAudioSessionRouteDescription()
                ]
            )

            // Then
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertEqual(lastRouteChangeReason, .oldDeviceUnavailable)
        }

        // MARK: - AudioSessionInterruptionDelegate

        func handleInterruption(type: AVAudioSession.InterruptionType, options: AVAudioSession.InterruptionOptions) {
            lastInterruptionType = type
            lastInterruptionOptions = options
            interruptionExpectation?.fulfill()
        }

        func handleRouteChange(reason: AVAudioSession.RouteChangeReason, previousRoute: AVAudioSessionRouteDescription) {
            lastRouteChangeReason = reason
            routeChangeExpectation?.fulfill()
        }
    }
#endif
