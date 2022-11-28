//
//  LogHelper.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import Foundation

class Logger: NSObject {
    
    private static let isLogging = (AppConfig.appMode == .development || AppConfig.appMode == .productionAndLogs) ? true : false
    
    //static let loginTag = "\(DateHelper().getTime()) : LoginVC -> "
    
    static func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if isLogging {
            items.forEach {
                Swift.print("⚪️ \($0)", separator: separator, terminator: terminator)
                write("⚪️ \(Date()): \($0) \n")
            }
        }
    }
    
    static func m(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if isLogging {
            items.forEach {
                Swift.print("🟢 \($0)", separator: separator, terminator: terminator)
                write("🟢 \(Date()): \($0) \n")
            }
        }
    }
    
    static func d(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if isLogging {
            items.forEach {
                Swift.print("🟡 \($0)", separator: separator, terminator: terminator)
                write("🟡 \(Date()): \($0) \n")
            }
        }
    }
    
    static func e(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if isLogging {
            items.forEach {
                Swift.print("🔴 \($0)", separator: separator, terminator: terminator)
                write("🔴 \(Date()): \($0) \n")
                
            }
        }
    }
    
    private static func write(_ string: String) {
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MHCPLogs.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
    
}

enum Log {
    
    enum LogLevel {
        case print
        case message
        case debug
        case error
        
        fileprivate var prefix: String {
            switch self {
                case .print:   return "INFO ⚪️"
                case .message: return "MESSAGE 🟢"
                case .debug:   return "DEBUG ⚠️"
                case .error:   return "ERROR ❌"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var isFunctionName = true
        var description: String {
            
            var str = ""
            
            str += "File -> \((file as NSString).lastPathComponent) "
            if isFunctionName {
                str += "Function -> \(function) "
            }
            str += "Line -> \(line)"
            
            return str
        }
    }
    
    static func print(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n\n",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        
        
        if AppConfig.appMode == .development || AppConfig.appMode == .productionAndLogs {
            
            let context = Context(file: file, function: function, line: line, isFunctionName: false)
            
            items.forEach {
                Swift.print(
                    "[\(LogLevel.print.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)", separator: separator, terminator: terminator
                )
                write("[\(LogLevel.print.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)\n\n")
            }
        }
        
//        Log.handleLog(
//            items,
//            separator: separator,
//            terminator: terminator,
//            level: .print,
//            context: context
//        )
    }
    
    static func m(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n\n",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        
        if AppConfig.appMode == .development || AppConfig.appMode == .productionAndLogs {
            
            let context = Context(file: file, function: function, line: line, isFunctionName: true)
            
            items.forEach {
                Swift.print(
                    "[\(LogLevel.message.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)", separator: separator, terminator: terminator
                )
                write("[\(LogLevel.message.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)\n\n")
            }
        }
        
//        Log.handleLog(
//            items,
//            separator: separator,
//            terminator: terminator,
//            level: .message,
//            context: context
//        )
    }
    
    static func d(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n\n",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        
        if AppConfig.appMode == .development || AppConfig.appMode == .productionAndLogs {
            
            let context = Context(file: file, function: function, line: line, isFunctionName: true)
            
            items.forEach {
                Swift.print(
                    "[\(LogLevel.debug.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)", separator: separator, terminator: terminator
                )
                write("[\(LogLevel.debug.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)\n\n")
            }
        }
        
//        Log.handleLog(
//            items,
//            separator: separator,
//            terminator: terminator,
//            level: .debug,
//            context: context
//        )
    }
    
    static func e(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n\n",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        
        if AppConfig.appMode == .development || AppConfig.appMode == .productionAndLogs {
            
            let context = Context(file: file, function: function, line: line, isFunctionName: true)
            
            items.forEach {
                Swift.print(
                    "[\(LogLevel.error.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)", separator: separator, terminator: terminator
                )
                write("[\(LogLevel.error.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)\n\n")
            }
        }
        
//        Log.handleLog(
//            items,
//            separator: separator,
//            terminator: terminator,
//            level: .error,
//            context: context
//        )
    }
    
//    fileprivate static func handleLog(
//        _ items: Any...,
//        separator: String = " ",
//        terminator: String = "\n\n",
//        level: LogLevel,
//        context: Context) {
//
//
//            items.forEach {
//                Swift.print("🔴 \($0)", separator: separator, terminator: terminator)
//                write("🔴 \(Date()): \($0) \n")
//
//            }
//
//            if AppConfig.appMode == .development {
//                items.forEach {
//                    Swift.print(
//                        "[\(level.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)",
//                        separator: separator,
//                        terminator: terminator
//                    )
//                    write("[\(level.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)\n\n")
//                }
//            }
      
//            if AppConfig.appMode == .development {
//                items.forEach {
//                    Swift.print(
//                        "\($0)",
//                        separator: separator,
//                        terminator: terminator
//                    )
//                    write("[\(level.prefix)] -> \(DateHelper.shared.getTime(date: Date())) -> \(context.description) :-> \($0)\n\n")
//                }
//            }
//
//    }
    
    private static func write(_ string: String) {
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MHCPLogs.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
    
}
