//
//  Created by Dimitrios Chatzieleftheriou on 02/06/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import Foundation

// MARK: Internal State

extension AudioPlayer {
    struct InternalState: OptionSet {
        var rawValue: Int

        static let initial = InternalState([])
        static let running = InternalState(rawValue: 1)
        static let playing = InternalState(rawValue: (1 << 1) | InternalState.running.rawValue)
        static let rebuffering = InternalState(rawValue: (1 << 2) | InternalState.running.rawValue)
        static let waitingForData = InternalState(rawValue: (1 << 3) | InternalState.running.rawValue)
        static let waitingForDataAfterSeek = InternalState(rawValue: (1 << 4) | InternalState.running.rawValue)
        static let paused = InternalState(rawValue: (1 << 5) | InternalState.running.rawValue)
        static let stopped = InternalState(rawValue: 1 << 9)
        static let pendingNext = InternalState(rawValue: 1 << 10)
        static let disposed = InternalState(rawValue: 1 << 30)
        static let error = InternalState(rawValue: 1 << 31)

        static let waiting = [.waitingForData, waitingForDataAfterSeek, .rebuffering]
    }
}

/// Helper method that returns `AudioPlayerState` and `StopReason` based on the given `InternalState`
/// - Parameter internalState: A value of `InternalState`
/// - Returns: A tuple of `(AudioPlayerState, AudioPlayerStopReason)`
func playerStateAndStopReason(
    for internalState: AudioPlayer.InternalState
) -> (state: AudioPlayerState, stopReason: AudioPlayerStopReason?) {
    switch internalState {
    case .initial:
        (.ready, AudioPlayerStopReason.none)
    case .running, .playing, .waitingForDataAfterSeek:
        (.playing, AudioPlayerStopReason.none)
    case .pendingNext, .rebuffering, .waitingForData:
        (.bufferring, AudioPlayerStopReason.none)
    case .stopped:
        (.stopped, nil)
    case .paused:
        (.paused, AudioPlayerStopReason.none)
    case .disposed:
        (.disposed, .userAction)
    case .error:
        (.error, AudioPlayerStopReason.error)
    default:
        (.ready, AudioPlayerStopReason.none)
    }
}

// MARK: Public States

public enum AudioPlayerState: Equatable, Sendable {
    case ready
    case running
    case playing
    case bufferring
    case paused
    case stopped
    case error
    case disposed
}

public enum AudioPlayerStopReason: Equatable, Sendable {
    case none
    case eof
    case userAction
    case error
    case disposed
}

public enum AudioPlayerError: LocalizedError, Equatable, Sendable {
    case streamParseBytesFailure(AudioFileStreamError)
    case audioSystemError(AudioSystemError)
    case codecError
    case dataNotFound
    case networkError(NetworkError)
    case other

    public var errorDescription: String? {
        switch self {
        case let .streamParseBytesFailure(status):
            "Couldn't parse the bytes from the stream. Status: \(status)"
        case let .audioSystemError(error):
            error.errorDescription
        case .codecError:
            "Codec error while parsing data packets"
        case .dataNotFound:
            "No data supplied from network stream"
        case let .networkError(error):
            error.localizedDescription
        case .other:
            "Audio Player error"
        }
    }
}

public enum AudioSystemError: LocalizedError, Equatable, Sendable {
    case engineFailure
    case playerNotFound
    case playerStartError
    case fileStreamError(AudioFileStreamError)
    case converterError(AudioConverterError)
    case sessionActivation
    case sessionSetupFailed

    public var errorDescription: String? {
        switch self {
        case .engineFailure: "Audio engine couldn't start"
        case .playerNotFound: "Player not found"
        case .playerStartError: "Player couldn't start"
        case let .fileStreamError(error):
            "Audio file stream error'd: \(error)"
        case let .converterError(error):
            "Audio converter error'd: \(error)"
        case .sessionActivation:
            "Audio session couldn't be activated"
        case .sessionSetupFailed:
            "Audio session setup failed"
        }
    }
}
