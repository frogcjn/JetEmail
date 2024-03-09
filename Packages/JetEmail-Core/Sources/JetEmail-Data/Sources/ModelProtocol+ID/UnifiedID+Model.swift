//
//  File.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//



import Microsoft
import Google
import JetEmail_Foundation

extension Account: UnifiedModel {
    public typealias MicrosoftID = Microsoft.ID
    public typealias    GoogleID =    Google.ID
    public typealias ID = UnifiedID<Account>
}

extension MailFolder: UnifiedModel {
    public typealias MicrosoftID = AccountModelID<Microsoft.Account, Microsoft.MailFolder>
    public typealias    GoogleID = AccountModelID<   Google.Account,    Google.MailFolder>
    public typealias ID = UnifiedID<MailFolder>
}

extension Message: UnifiedModel {
    public typealias MicrosoftID = AccountModelID<Microsoft.Account, Microsoft.Message>
    public typealias    GoogleID = AccountModelID<   Google.Account,    Google.Message>
    public typealias ID = UnifiedID<Message>
}

public extension UnifiedID<Account> {
    var innerID: String {
        switch self {
        case .microsoft(let id): id.rawValue
        case    .google(let id): id.rawValue
        }
    }
}

public extension UnifiedID<MailFolder> {
    var innerID: String {
        switch self {
        case .microsoft(let id): id.innerID.rawValue
        case    .google(let id): id.innerID.rawValue
        }
    }
    
    var innerAccountID : String {
        switch self {
        case .microsoft(let id): id.accountID.rawValue
        case    .google(let id): id.accountID.rawValue
        }
    }
}

public extension UnifiedID<Message> {
    var innerID: String {
        switch self {
        case .microsoft(let id): id.innerID.rawValue
        case    .google(let id): id.innerID.rawValue
        }
    }
    
    var innerAccountID : String {
        switch self {
        case .microsoft(let id): id.accountID.rawValue
        case    .google(let id): id.accountID.rawValue
        }
    }
}
