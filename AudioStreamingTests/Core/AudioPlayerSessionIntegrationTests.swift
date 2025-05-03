//
//  AudioPlayerSessionIntegrationTests.swift
//  AudioStreamingTests
//
//  Created by Dionisis Karatzas.
//  Copyright © 2025 Dionisis Karatzas. All rights reserved.
//

#if !os(macOS)
    import XCTest
    import AVFoundation
    @testable import AudioStreaming

    final class AudioPlayerSessionIntegrationTests: XCTestCase, AudioPlayerDelegate {
        var audioPlayer: AudioPlayer!
        var stateChangeExpectations: [AudioPlayerState: XCTestExpectation] = [:]
        var lastStateChange: (previous: AudioPlayerState, current: AudioPlayerState)?

        // Use a local test audio URL that doesn't require network access
        let testAudioURL = Bundle.module.url(forResource: "raw-stream-audio-empty-metadata", withExtension: nil)!

        override func setUp() {
            super.setUp()
            audioPlayer = AudioPlayer()
            audioPlayer.delegate = self
        }

        override func tearDown() {
            audioPlayer.stop()
            audioPlayer.delegate = nil
            audioPlayer = nil
            stateChangeExpectations = [:]
            lastStateChange = nil
            super.tearDown()
        }

        // MARK: - Test Cases

        func testInterruptionBegan() {
            // Set up expectation for state change to playing
            stateChangeExpectations[.playing] = expectation(description: "Player should start playing")

            // Start playback
            audioPlayer.play(url: testAudioURL)

            // Wait for player to start playing
            waitForExpectations(timeout: 2.0, handler: nil)

            // Reset expectations
            stateChangeExpectations = [:]

            // Set up expectation for state change to paused
            stateChangeExpectations[.paused] = expectation(description: "Player should pause on interruption")

            // When: Directly call the interruption handler with began type
            audioPlayer.handleInterruption(type: .began, options: [])

            // Allow time for state transition
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertEqual(audioPlayer.state, .paused, "Player should be paused after interruption began")
        }

        func testInterruptionEndedWithResume() {
            // Set up expectation for state change to playing
            stateChangeExpectations[.playing] = expectation(description: "Player should start playing")

            // Start playback
            audioPlayer.play(url: testAudioURL)

            // Wait for player to start playing
            waitForExpectations(timeout: 2.0, handler: nil)

            // Reset expectations
            stateChangeExpectations = [:]

            // Ensure player is paused first
            stateChangeExpectations[.paused] = expectation(description: "Player should pause")
            audioPlayer.pause()
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertEqual(audioPlayer.state, .paused, "Player should be paused before test")

            // Reset expectations
            stateChangeExpectations = [:]

            // Set up expectation for state change to playing
            stateChangeExpectations[.playing] = expectation(description: "Player should resume on interruption ended with resume option")

            // When: Directly call the interruption handler with ended type and shouldResume option
            audioPlayer.handleInterruption(type: .ended, options: .shouldResume)

            // Allow time for state transition
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertEqual(audioPlayer.state, .playing, "Player should be playing after interruption ended with resume option")
        }

        func testRouteChangeOldDeviceUnavailable() {
            // Set up expectation for state change to playing
            stateChangeExpectations[.playing] = expectation(description: "Player should start playing")

            // Start playback
            audioPlayer.play(url: testAudioURL)

            // Wait for player to start playing
            waitForExpectations(timeout: 2.0, handler: nil)

            // Reset expectations
            stateChangeExpectations = [:]

            // Set up expectation for state change to paused
            stateChangeExpectations[.paused] = expectation(description: "Player should pause when device becomes unavailable")

            // When: Directly call the route change handler with oldDeviceUnavailable reason
            audioPlayer.handleRouteChange(reason: .oldDeviceUnavailable, previousRoute: AVAudioSessionRouteDescription())

            // Allow time for state transition
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertEqual(audioPlayer.state, .paused, "Player should be paused after device became unavailable")
        }

        // MARK: - AudioPlayerDelegate

        func audioPlayerStateChanged(player: AudioPlayer, with newState: AudioPlayerState, previous oldState: AudioPlayerState) {
            lastStateChange = (previous: oldState, current: newState)
            if let expectation = stateChangeExpectations[newState] {
                expectation.fulfill()
            }
        }

        func audioPlayerDidStartPlaying(player: AudioPlayer, with entryId: AudioEntryId) {}
        func audioPlayerDidFinishPlaying(player: AudioPlayer, entryId: AudioEntryId, stopReason: AudioPlayerStopReason, progress: Double, duration: Double) {}
        func audioPlayerDidFinishBuffering(player: AudioPlayer, with entryId: AudioEntryId) {}
        func audioPlayerWillStartPlaying(player: AudioPlayer, with entryId: AudioEntryId) {}
        func audioPlayerDidCancel(player: AudioPlayer, queuedItems: [AudioEntryId]) {}
        func audioPlayerUnexpectedError(player: AudioPlayer, error: AudioPlayerError) {}
        func audioPlayerDidReadMetadata(player: AudioPlayer, metadata: [String: String]) {}
    }
#endif
