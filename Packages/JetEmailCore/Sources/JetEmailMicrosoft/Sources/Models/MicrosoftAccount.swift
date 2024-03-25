//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

import JetEmailData

public struct MicrosoftAccount : MicrosoftProtocol, PlatformSpecificAccountProtocol, AccountProtocol {
    public typealias GeneralID = AccountID
    
    public let                  id: MicrosoftAccountID
    public let            username: String

    init(id: MicrosoftAccountID, username: String) {
        self.id       = id
        self.username = username
    }
}
