//
//  Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/21/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailID


public extension Session {
    /*var accountID: AccountID {
        switch self {
        case .microsoft(let microsoftSession): microsoftSession.account.id.general
        case .google   (let googleSession   ):    googleSession.account.id.general
        }
    }*/
}

public extension Session {
    /*var username: String {
        switch self {
        case .microsoft(let microsoftSession): microsoftSession.username
        case    .google(let    googleSession):    googleSession.username
        }
    }*/
}

public extension Session {
    /*var microsoft: MicrosoftSession? {
        guard case .microsoft(let microsoft) = self else { return nil }
        return microsoft
    }
    
    var google: GoogleSession? {
        guard case .google(let google) = self else { return nil }
        return google
    }*/
}
