//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

public protocol AccountIDSessionAPI {
    associatedtype SessionType
    
    @MainActor
    var storedSession: SessionType? { get }
    
    @MainActor
    var refreshSession: SessionType? { get async throws }
    
    @MainActor
    func removeSession() -> SessionType?
}

public extension AccountIDSessionAPI {
    
    @MainActor
    var sessionState: SessionState {
        storedSession != nil ? .hasSession : .noSession
    }
}


import SwiftUI

public enum SessionState : String, Codable {
    case noSession // no account return from platform client cached account store
    case hasSession // no valid session return from platform client cached account
    
    public var color: Color {
        switch self {
        case .hasSession: .green
        case .noSession: .red
        }
    }
}
