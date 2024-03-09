//
//  Account.State.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftUI

enum SessionState : String, Codable {
    case noSession // no account return from platform client cached account store
    case hasSession // no valid session return from platform client cached account
    
    var color: Color {
        switch self {
        case .hasSession: .green
        case .noSession: .red
        }
    }
}
