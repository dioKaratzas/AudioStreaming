//
//  Logger.swift
//  AppModules
//
//  Created by Dionisis Karatzas on 7 May 2025
//

import Logging
import Foundation

public private(set) var level: Logger.Level = .debug

public enum LogCategory: String {
    case audioRendering = "rendering"
    case networking = "networking"
    case backgroundHandler = "backgroundHandler"
    case generic = "generic"
}

/// Convenience: `logger(.networking).info("…")`
public func logger(_ c: LogCategory) -> Logger {
    var logger = Logger(label: "audio.streaming.log.\(c.rawValue)")
    logger.logLevel = level
    return logger
}
