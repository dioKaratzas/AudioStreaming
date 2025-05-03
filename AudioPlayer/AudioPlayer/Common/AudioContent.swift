//
//  Created by Dimitris C.
//  Copyright © 2024 Decimal. All rights reserved.
//

import Foundation

enum AudioContent {
    case offradio
    case enlefko
    case pepper966
    case kosmos
    case kosmosJazz
    case radiox
    case khruangbin
    case piano
    case optimized
    case nonOptimized
    case remoteWave
    case local
    case localWave
    case loopBeatFlac
    case custom(String)

    var title: String {
        switch self {
        case .offradio:
            "Offradio"
        case .enlefko:
            "Enlefko"
        case .pepper966:
            "Pepper 96.6"
        case .kosmos:
            "Kosmos 93.6"
        case .kosmosJazz:
            "Kosmos Jazz"
        case .radiox:
            "Radio X"
        case .khruangbin:
            "Khruangbin"
        case .piano:
            "Piano"
        case .remoteWave:
            "Sample remote"
        case .local:
            "Jazzy Frenchy"
        case .localWave:
            "Local file"
        case .optimized:
            "Jazzy Frenchy"
        case .nonOptimized:
            "Jazzy Frenchy"
        case .loopBeatFlac:
            "Beat loop"
        case let .custom(url):
            url
        }
    }

    var subtitle: String? {
        switch self {
        case .offradio:
            "Stream • offradio.gr"
        case .enlefko:
            "Stream • enlefko.fm"
        case .pepper966:
            "Stream • pepper966.gr"
        case .kosmos:
            "Stream • ertecho.gr"
        case .kosmosJazz:
            "Stream • ertecho.gr"
        case .radiox:
            "Stream • globalplayer.com"
        case .khruangbin:
            "Remote mp3"
        case .piano:
            "Remote mp3"
        case .remoteWave:
            "wave"
        case .local:
            "Music by: bensound.com"
        case .localWave:
            "Music by: bensound.com"
        case .optimized:
            "Music by: bensound.com - m4a optimized"
        case .nonOptimized:
            "Music by: bensound.com - m4a non-optimized"
        case .loopBeatFlac:
            "Remote flac"
        case .custom:
            ""
        }
    }

    var streamUrl: URL {
        switch self {
        case .enlefko:
            return URL(string: "https://stream.radiojar.com/srzwv225e3quv")!
        case .offradio:
            return URL(string: "https://s3.yesstreaming.net:17062/stream")!
        case .pepper966:
            return URL(string: "https://n04.radiojar.com/pepper.m4a?1662039818=&rj-tok=AAABgvlUaioALhdOXDt0mgajoA&rj-ttl=5")!
        case .kosmos:
            return URL(string: "https://radiostreaming.ert.gr/ert-kosmos")!
        case .kosmosJazz:
            return URL(string: "https://radiostreaming.ert.gr/ert-webjazz")!
        case .radiox:
            return URL(string: "https://media-ssl.musicradio.com/RadioXLondon")!
        case .khruangbin:
            return URL(string: "https://p.scdn.co/mp3-preview/cab4b09c23ffc11774d879977131df9d150fcef4?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!
        case .piano:
            return URL(string: "https://www.kozco.com/tech/piano2-CoolEdit.mp3")!
        case .optimized:
            return URL(string: "https://github.com/dimitris-c/sample-audio/raw/main/bensound-jazzyfrenchy-optimized.m4a")!
        case .nonOptimized:
            return URL(string: "https://github.com/dimitris-c/sample-audio/raw/main/bensound-jazzyfrenchy.m4a")!
        case .local:
            let path = Bundle.main.path(forResource: "bensound-jazzyfrenchy", ofType: "mp3")!
            return URL(fileURLWithPath: path)
        case .localWave:
            let path = Bundle.main.path(forResource: "hipjazz", ofType: "wav")!
            return URL(fileURLWithPath: path)
        case .remoteWave:
            return URL(string: "https://github.com/dimitris-c/sample-audio/raw/main/5-MB-WAV.wav")!
        case .loopBeatFlac:
            return URL(string: "https://github.com/dimitris-c/sample-audio/raw/main/drumbeat-loop.flac")!
        case let .custom(url):
            return URL(string: url)!
        }
    }
}
