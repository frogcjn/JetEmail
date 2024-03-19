//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//


public extension AccountID {
    var platformCase: PlatformEnum<MicrosoftAccountID, GoogleAccountID>? {
        switch platform {
        case .microsoft: .microsoft(.init(innerID: innerID))
        case    .google:    .google(.init(innerID: innerID))
        case     .other: nil
        }
    }
    
    var microsoft: MicrosoftAccountID? {
        guard platform == .microsoft  else { return nil }
        return .init(innerID: innerID)
    }
    
    var google: GoogleAccountID? {
        guard platform == .google else { return nil }
        return .init(innerID: innerID)
    }
}

public extension MailFolderID {
    var microsoft: MicrosoftMailFolderID? {
        guard let accountID = accountID.microsoft else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
    
    var google: GoogleMailFolderID? {
        guard let accountID = accountID.google else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
}

public extension MessageID {
    var microsoft: MicrosoftMessageID? {
        guard let accountID = accountID.microsoft else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
    
    var google: GoogleMessageID? {
        guard let accountID = accountID.google else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
}
