//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import JetEmail_ID

// MARK: - MailFolder
// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

public struct MicrosoftMailFolder : CodableValueType {
    public let                  id: MicrosoftMailFolderID
    public let               inner: Inner
    public var wellKnownFolderName: WellKnownFolderName?

    
    init(_ session: Session, inner: Inner) {
        self.id    = .init(accountID: session.accountID, innerID: inner.id)
        self.inner = inner
    }
}

extension MicrosoftMailFolder {
    public struct Inner : CodableValueType {
        public var               id: String
        public var      displayName: String?
        public var         isHidden: Bool?
        
        // parent-children relationship
        public var   parentFolderId: String?
        public var childFolderCount: Int32?
        
        // mailFolder-messages relationship
        public var  unreadItemCount: Int32?
        public var   totalItemCount: Int32?
    }
}

public extension MicrosoftMailFolder.Inner {
    func outer(_ session: Session) -> MicrosoftMailFolder {
        .init(session, inner: self)
    }
}
