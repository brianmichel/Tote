//
//  Log.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import CocoaLumberjack
import Foundation

private var logLevel: DDLogLevel = .all

final class Log {
    private static let logger: DDLog = {
        DDLog.add(DDOSLogger.sharedInstance) // ASL = Apple System Logs

        let logFormatter = LogFormatter()
        DDOSLogger.sharedInstance.logFormatter = logFormatter

        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24) // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)

        return DDLog.sharedInstance
    }()

    class func info(_ message: @autoclosure () -> String,
                    _ path: StaticString = #file,
                    _ function: StaticString = #function,
                    line: UInt = #line) {
        _DDLogMessage(message(),
                      level: logLevel,
                      flag: .info,
                      context: 0,
                      file: path,
                      function: function,
                      line: line,
                      tag: nil,
                      asynchronous: true,
                      ddlog: logger)
    }

    class func debug(_ message: @autoclosure () -> String,
                     _ path: StaticString = #file,
                     _ function: StaticString = #function,
                     line: UInt = #line) {
        _DDLogMessage(message(),
                      level: logLevel,
                      flag: .debug,
                      context: 0,
                      file: path,
                      function: function,
                      line: line,
                      tag: nil,
                      asynchronous: true,
                      ddlog: logger)
    }

    class func warn(_ message: @autoclosure () -> String,
                    _ path: StaticString = #file,
                    _ function: StaticString = #function,
                    line: UInt = #line) {
        _DDLogMessage(message(),
                      level: logLevel,
                      flag: .warning,
                      context: 0,
                      file: path,
                      function: function,
                      line: line,
                      tag: nil,
                      asynchronous: true,
                      ddlog: logger)
    }

    class func error(_ message: @autoclosure () -> String,
                     _ path: StaticString = #file,
                     _ function: StaticString = #function,
                     line: UInt = #line) {
        _DDLogMessage(message(),
                      level: logLevel,
                      flag: .error,
                      context: 0,
                      file: path,
                      function: function,
                      line: line,
                      tag: nil,
                      asynchronous: true,
                      ddlog: logger)
    }
}
