//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmailFoundation

public enum PlatformCase<Microsoft, Google> {
    case microsoft(Microsoft)
    case    google(Google)
}

extension PlatformCase : Sendable where Microsoft : Sendable, Google : Sendable {}
extension PlatformCase : Equatable where Microsoft : Equatable, Google : Equatable {}
extension PlatformCase : Hashable where Microsoft : Hashable, Google : Hashable {}
extension PlatformCase : Codable where Microsoft : Codable, Google : Codable {}
