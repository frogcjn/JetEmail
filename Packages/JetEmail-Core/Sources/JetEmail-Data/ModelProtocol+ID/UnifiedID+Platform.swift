//
//  UnifiedID+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import Microsoft
import Google

public extension UnifiedID {
    var platform: Platform {
        switch self {
        case .microsoft: .microsoft
        case .google   : .google
        }
    }
    
    var platformID: String {
        switch self {
        case .microsoft(let platformID): platformID.rawValue
        case .google   (let platformID): platformID.rawValue
        }
    }
    

    init(platform: Platform, platformID: String) {
        self = switch platform {
        case .microsoft: .microsoft(.init(rawValue: platformID))
        case .google   : .google   (.init(rawValue: platformID))
        }
    }
}

