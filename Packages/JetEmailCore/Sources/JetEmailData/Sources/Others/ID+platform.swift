//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//


public extension AccountID {
    var platformCase: PlatformEnum<MicrosoftAccountID, GoogleAccountID> { get throws {
        switch platform {
        case .microsoft: .microsoft(.init(innerID: innerID))
        case    .google:    .google(.init(innerID: innerID))
        default        : throw PlatformEnumError.noPlatform(platform)
        }
    } }
}

public extension MailFolderID {
    var platformCase: PlatformEnum<MicrosoftMailFolderID, GoogleMailFolderID> { get throws {
        switch try accountID.platformCase {
        case .microsoft(let accountID): .microsoft(.init(accountID: accountID, innerID: innerID))
        case    .google(let accountID):    .google(.init(accountID: accountID, innerID: innerID))
        // default                       : throw PlatformEnumError.noPlatform(platform)
        }
    } }
}

public extension MessageID {
    var platformCase: PlatformEnum<MicrosoftMessageID, GoogleMessageID> { get throws {
        switch try accountID.platformCase {
        case .microsoft(let accountID): .microsoft(.init(accountID: accountID, innerID: innerID))
        case    .google(let accountID):    .google(.init(accountID: accountID, innerID: innerID))
        // default                       : throw PlatformEnumError.noPlatform(platform)
        }
    } }
}


public extension AccountID {
    var microsoft: MicrosoftAccountID { get throws { try platformCase.microsoft } }
    var google   : GoogleAccountID    { get throws { try platformCase.google    } }
}

public extension MailFolderID {
    var microsoft: MicrosoftMailFolderID { get throws { try platformCase.microsoft } }
    var google   : GoogleMailFolderID    { get throws { try platformCase.google    } }
}


public extension MessageID {
    var microsoft: MicrosoftMessageID { get throws { try platformCase.microsoft } }
    var google   : GoogleMessageID    { get throws { try platformCase.google    } }
}
