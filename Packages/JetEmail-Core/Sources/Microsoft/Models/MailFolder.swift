//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import JetEmail_Foundation

// MARK: - MailFolder
// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

public struct MailFolder : IdentifiableValueType {
    public var                  id: ID
    public var         displayName: String?
    public var wellKnownFolderName: WellKnownFolderName?
    public var            isHidden: Bool?
    
    // parent-children relationship
    public var      parentFolderId: ID?
    public var    childFolderCount: Int32?
    
    // mailFolder-messages relationship
    public var     unreadItemCount: Int32?
    public var      totalItemCount: Int32?
}
