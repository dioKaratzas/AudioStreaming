//
//  Created by Dimitrios Chatzieleftheriou on 28/07/2020.
//  Copyright © 2020 Decimal. All rights reserved.
//

import os
import Foundation

private let loggingSubsystem = "audio.streaming.log"

enum Logger {
    private static let audioRendering = OSLog(subsystem: loggingSubsystem, category: "audio.rendering")
    private static let networking = OSLog(subsystem: loggingSubsystem, category: "audio.networking")
    private static let generic = OSLog(subsystem: loggingSubsystem, category: "audio.streaming.generic")

    /// Defines is the the logger displays any logs
    static var isEnabled = true

    enum Category: CaseIterable {
        case audioRendering
        case networking
        case generic

        func toOSLog() -> OSLog {
            switch self {
            case .audioRendering: Logger.audioRendering
            case .networking: Logger.networking
            case .generic: Logger.generic
            }
        }
    }

    static func error(_ message: StaticString, category: Category, args: CVarArg...) {
        process(message, category: category, type: .error, args: args)
    }

    static func error(_ message: StaticString, category: Category) {
        error(message, category: category, args: [])
    }

    static func debug(_ message: StaticString, category: Category, args: CVarArg...) {
        process(message, category: category, type: .debug, args: args)
    }

    static func debug(_ message: StaticString, category: Category) {
        debug(message, category: category, args: [])
    }

    private static func process(_ message: StaticString, category: Category, type: OSLogType, args: CVarArg...) {
        guard isEnabled else {
            return
        }
        os_log(message, log: category.toOSLog(), type: type, args)
    }
}
