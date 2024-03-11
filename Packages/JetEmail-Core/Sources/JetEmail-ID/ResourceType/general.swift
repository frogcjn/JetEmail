//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

extension AccountIDProtocol where Self : PlatformSpecific {
    public var general: AccountID {
        .init(platform: platform, innerID: innerID)
    }
}

extension MailFolderIDProtocol where Self : PlatformSpecific, AccountIDType : PlatformSpecific {
    public var general: MailFolderID {
        .init(platform: platform, accountID: accountID.general, innerID: innerID)
    }
}

extension MessageIDProtocol where Self : PlatformSpecific, AccountIDType : PlatformSpecific {
    public var general: MessageID {
        .init(platform: platform, accountID: accountID.general, innerID: innerID)
    }
}
