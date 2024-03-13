//
//  JSON.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation

public extension String {
    var data: Data { get throws {
        guard let data = data(using: .utf8) else { throw FoudnationError.stringToData }
        return data
    } }
    func decodeJSON<T: Decodable>(_ type: T.Type) throws -> T {
        return try data.decodeJSON(type)
    }
}

public extension Data {
    // // String(decoding: self, as: UTF8.self)
    var string: String { get throws {
        guard let string = String(data: self, encoding: .utf8) else { throw FoudnationError.dataToString }
        return string
    } }
    func decodeJSON<T: Decodable>(_ type: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
}

/*public extension Result {
    func catching<T>(_ closure: @escaping () async throws -> T) async -> Result<T, Error> {
        await Task { try await closure() }.result
    }
}*/

public extension Encodable {
    var jsonString: String { get throws {
        try jsonData.string
    } }
}

public extension Encodable {
    var jsonData: Data { get throws {
        try JSONEncoder().encode(self)
    } }
    /*
     func jsonData() throws -> Data {
         try JSONEncoder().encode(self)
     }
     */
}




import SwiftData

/*extension PersistentModel {
    func to(_ modelContext: ModelContext) throws -> Self {
        guard let transfered = modelContext.model(for: persistentID) as? Self else {
            throw SwiftDataError.noModelInstance(id: persistentID, in: modelContext)
        }
        return transfered
    }
}*/
/*
extension Sequence where Element: PersistentModel {
    func to(_ modelContext: ModelContext) throws -> [Element] {
        try map { try $0.to(modelContext) }
    }
}
*/

public extension Collection {
    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}




public extension Sequence {
    func asyncMap<T>(
        _ transform: @Sendable (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
}

public extension Sequence where Element: Sendable {
    func forEachTask(operation: @Sendable @escaping (Element) async throws -> Void) async throws { // TODO: Swift 6.0, infer actor
        try await withThrowingDiscardingTaskGroup { group in
            forEach { element in
                group.addTask { try await operation(element) }
            }
        }
    }
}

public extension Date {
    func formattedRelative() -> String {
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

public extension Locale {
    static let enUSPosix = Locale(identifier: "en_US_POSIX")
}


public extension String {
    var isHTMLString: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "<[a-z][\\s\\S]*>", options: .caseInsensitive)
            let range = NSRange(startIndex..., in: self)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            return false
        }
    }

    var removingHTMLTags: String {
        if isHTMLString {
            replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        } else {
            self
        }
    }
}

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension String {
    var removingHTMLEntities: String {
        let encodedString = self
        guard let data = encodedString.data(using: .utf8) else {
            return encodedString
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return encodedString
        }
    }
}
