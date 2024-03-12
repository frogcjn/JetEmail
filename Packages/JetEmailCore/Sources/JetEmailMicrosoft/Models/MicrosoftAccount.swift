//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

import JetEmailID

public struct MicrosoftAccount : MicrosoftProtocol, PlatformSpecificAccountProtocol, GetAccountProtocol {
    public typealias GeneralID = AccountID
    
    public let                  id: MicrosoftAccountID
    public let            username: String

    public init(id: MicrosoftAccountID, username: String) {
        self.id       = id
        self.username = username
    }
}
