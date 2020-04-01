//
//  LogFormatter.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import CocoaLumberjack

final class LogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        return "\(logLevelName(from: logMessage)) \(Int(logMessage.timestamp.timeIntervalSince1970)) - \(logMessage.message)"
    }

    private func logLevelName(from message: DDLogMessage) -> String {
        switch message.flag {
        case .error:
            return "❗️"
        case .warning:
            return "⚠️"
        case .info:
            return "ℹ️"
        case .debug:
            return "🛠"
        default:
            return "🤷‍♀️"
        }
    }
}
