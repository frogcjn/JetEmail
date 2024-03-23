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
        default        : nil
        }
    }
}

public extension MailFolderID {
    var platformCase: PlatformEnum<MicrosoftMailFolderID, GoogleMailFolderID>? {
        switch accountID.platformCase {
        case .microsoft(let accountID): .microsoft(.init(accountID: accountID, innerID: innerID))
        case    .google(let accountID):    .google(.init(accountID: accountID, innerID: innerID))
        default                       : nil
        }
    }
}

public extension MessageID {
    var platformCase: PlatformEnum<MicrosoftMessageID, GoogleMessageID>? {
        switch accountID.platformCase {
        case .microsoft(let accountID): .microsoft(.init(accountID: accountID, innerID: innerID))
        case    .google(let accountID):    .google(.init(accountID: accountID, innerID: innerID))
        default                       : nil
        }
    }
}


public extension AccountID {
    var microsoft: MicrosoftAccountID? { platformCase?.microsoft }
    var google   : GoogleAccountID?    { platformCase?.google    }
}

public extension MailFolderID {
    var microsoft: MicrosoftMailFolderID? { platformCase?.microsoft }
    var google   : GoogleMailFolderID?    { platformCase?.google    }
}


public extension MessageID {
    var microsoft: MicrosoftMessageID? { platformCase?.microsoft }
    var google   : GoogleMessageID?    { platformCase?.google }
}
