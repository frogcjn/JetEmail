//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

import JetEmailID

public struct GoogleAccount : GoogleProtocol, PlatformSpecificAccountProtocol, AccountProtocol {
    public typealias GeneralID = AccountID
    
    public let                  id: GoogleAccountID
    public let            username: String

    public init(id: GoogleAccountID, username: String) {
        self.id       = id
        self.username = username
    }
}
