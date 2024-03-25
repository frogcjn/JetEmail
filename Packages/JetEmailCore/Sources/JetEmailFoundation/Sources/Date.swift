//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/25/24.
//

import struct Foundation.Date
import struct Foundation.Locale
import struct Foundation.TimeInterval
import struct Foundation.Calendar

// MARK: - Date

public extension Date {
    var formattedRelative: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: .now)
        switch components.day ?? 0 {
        case 3...:
            return formatted(.dateTime.day(.defaultDigits).month(.defaultDigits).year(.defaultDigits))
        default:
            return formatted(.relative(presentation: .named)/*.locale(.current)*/)
        }
    }
}

public extension String {
    
    var iso8601: Date? {
        try? Date.ISO8601FormatStyle().parse(self)
        // ISO8601DateFormatter().date(from: rawValue) else { return nil }
    }
    
    var rfc2822 : Date? {
        // "EEE, dd MMM yyyy HH:mm:ss Z"
        let format: Date.FormatString = """
            \(weekday: .abbreviated), \(day: .twoDigits) \(month: .abbreviated) \(year: .padded(4)) \
            \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \
            \(timeZone: .iso8601(.short))
        """
        
        let strategy = Date.ParseStrategy(
            format: format,
            locale: .enUSPosix,
            timeZone: .gmt
        )
        // let strategy2 = Date.ParseStrategy.fixed(format: format, timeZone: .gmt/* Locale(identifier: "en_US_POSIX")*/ /* locale: Locale(identifier: "en_US_POSIX")*/)
        
        // assert(strategy.format == "EEE', 'dd' 'MMM' 'yyyy' 'HH':'mm':'ss' 'Z")
        
        return try? strategy.parse(self)
    }
}

public extension Int64 {
    var milliSecondsTimeIntervalSince1970: Date? {
        Date(timeIntervalSince1970: TimeInterval(self / 1000))
    }
}

fileprivate extension Locale {
    static let enUSPosix = Locale(identifier: "en_US_POSIX")
}
