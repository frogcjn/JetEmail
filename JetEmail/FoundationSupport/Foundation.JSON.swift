//
//  JSON.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation

extension String {
    func decodeJSON<T: Decodable>(_ type: T.Type) -> T? {
        data(using: .utf8)
            .flatMap { try? JSONDecoder().decode(T.self, from: $0) }
    }
}

extension Encodable {
    func encodeJSON() -> String? {
        (try? JSONEncoder().encode(self))
            .flatMap { String(data: $0, encoding: .utf8) }
    }
}

extension Date {
    func formattedRelative() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: .now)
        switch components.day ?? 0 {
        case 3...:
            return self.formatted(.dateTime.day(.defaultDigits).month(.defaultDigits).year(.defaultDigits))
        default:
            return self.formatted(.relative(presentation: .named)/*.locale(.current)*/)
        }
    }
}
