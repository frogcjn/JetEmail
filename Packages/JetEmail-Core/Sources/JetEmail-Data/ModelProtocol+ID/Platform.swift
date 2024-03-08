//
//  Platform.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

public enum Platform : String {
    case microsoft
    case google
}

extension Platform: Equatable, Hashable, Codable {}
extension Platform: Sendable {}
