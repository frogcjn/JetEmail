//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public enum PlatformEnum<Microsoft, Google> {
    case microsoft(Microsoft)
    case    google(Google   )
}

public extension PlatformEnum {
    var microsoft: Microsoft? {
        guard case .microsoft(let microsoft) = self else { return nil }
        return microsoft
    }
    
    var google   : Google?    {
        guard case .google   (let google   ) = self else { return nil }
        return google
    }
}

extension PlatformEnum:  Sendable where Microsoft :  Sendable, Google :  Sendable {}
extension PlatformEnum: Equatable where Microsoft : Equatable, Google : Equatable {}
extension PlatformEnum:  Hashable where Microsoft :  Hashable, Google :  Hashable {}
extension PlatformEnum:   Codable where Microsoft :   Codable, Google :   Codable {}

extension PlatformEnum : Identifiable, GeneralIdentifiable where
    Microsoft : GeneralIdentifiable,
    Google    : GeneralIdentifiable,
    Microsoft.GeneralID == Google.GeneralID
{
    public typealias GeneralID = Microsoft.GeneralID
    
    public var generalID: GeneralID {
        switch self {
        case .microsoft(let platform): platform.generalID
        case    .google(let platform): platform.generalID
        }
    }
}