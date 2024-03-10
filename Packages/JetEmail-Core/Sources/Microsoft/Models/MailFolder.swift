//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import JetEmail_Foundation

// MARK: - MailFolder
// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

public struct MicrosoftMailFolder : CodableValueType {
    public let   id: MicrosoftMailFolderID
    public var data: MailFolder
    
    init(_ session: Session, data: MailFolder) {
        self.id   = .init(accountID: session.accountID, innerID: data.id)
        self.data = data
    }
}


public struct MailFolder : CodableValueType {
    public var                  id: String
    public var         displayName: String?
    public var wellKnownFolderName: WellKnownFolderName?
    public var            isHidden: Bool?
    
    // parent-children relationship
    public var      parentFolderId: String?
    public var    childFolderCount: Int32?
    
    // mailFolder-messages relationship
    public var     unreadItemCount: Int32?
    public var      totalItemCount: Int32?
}

public extension MailFolder {
    func with(session: Session) -> MicrosoftMailFolder {
        .init(session, data: self)
    }
}
