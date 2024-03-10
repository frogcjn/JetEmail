//
//  Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/21/24.
//

import Google
import Microsoft

public enum Session : Sendable {
    case microsoft(Microsoft.Session)
    case    google(   Google.Session)
}

public extension Session {
    var accountID: JetEmail_Data.Account.ID {
        switch self {
        case .microsoft(let microsoftSession): microsoftSession.accountID.general
        case .google   (let googleSession   ):    googleSession.accountID.general
        }
    }
}

public extension Session {
    var username: String {
        switch self {
        case .microsoft(let microsoftSession): microsoftSession.username
        case    .google(let    googleSession):    googleSession.username
        }
    }
}

public extension Session {
    var microsoft: Microsoft.Session? {
        guard case .microsoft(let microsoft) = self else { return nil }
        return microsoft
    }
    
    var google: Google.Session? {
        guard case .google(let google) = self else { return nil }
        return google
    }
}
