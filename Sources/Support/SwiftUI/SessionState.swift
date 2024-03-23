//
//  SessionState.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/19/24.
//

import JetEmailData

@MainActor
public extension Account {
    var sessionState: SessionState {
        storedSession != nil ? .hasSession : .noSession
    }
}


import struct SwiftUI.Color

public enum SessionState : String, Codable {
    case  noSession // no account return from platform client cached account store
    case hasSession // no valid session return from platform client cached account
    
    public var color: Color {
        switch self {
        case .hasSession: .green
        case  .noSession: .red
        }
    }
}
