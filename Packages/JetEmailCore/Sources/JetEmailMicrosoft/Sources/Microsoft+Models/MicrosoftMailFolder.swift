//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import JetEmailData

// MARK: - MailFolder
// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

public struct MicrosoftMailFolder : MicrosoftProtocol, PlatformSpecificMailFolderProtocol {
    public typealias GeneralID = MailFolderID
    
    public let         id: MicrosoftMailFolderID
    public let      inner: MicrosoftMailFolderInner
    
    public let systemName: MicrosoftMailFolderSystemName?
    public var systemInfo: MailFolderSystemInfo?

    public var       name: String? { inner.displayName }

    public init(id: MicrosoftMailFolderID, inner: MicrosoftMailFolderInner, systemName: MicrosoftMailFolderSystemName?) {
        self.id         = id
        self.inner      = inner
        
        if let systemName = systemName {
            self.systemName = systemName
            self.systemInfo = systemName.systemInfo
        } else {
            self.systemName = nil
            self.systemInfo = nil
        }
    }
}

public struct MicrosoftMailFolderInner : CodableValueType, Sendable {
    public let               id: String
    public let      displayName: String?
    public let         isHidden: Bool?
    
    // parent-children relationship
    public let   parentFolderId: String?
    public let childFolderCount: Int32?
    
    // mailFolder-messages relationship
    public let  unreadItemCount: Int32?
    public let   totalItemCount: Int32?
}

