//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import MSAL

// MARK: - MailFolder

// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

public struct MailFolder : Codable, Identifiable {
    public let               id: ID
    public let      displayName: String?
    public let         isHidden: Bool?
    
    // parent-children relationship
    public let   parentFolderId: ID?
    public let childFolderCount: Int32?
    
    // mailFolder-messages relationship
    public let  unreadItemCount: Int32?
    public let   totalItemCount: Int32?
}

extension MailFolder : Hashable {
    public static func == (lhs: Microsoft.MailFolder, rhs: Microsoft.MailFolder) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: MailFolder.WellknownFolderName

public extension MailFolder {
    // Well-known folder names https://learn.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0#methods
    
    enum WellKnownFolderName : String {
        case msgFolderRoot = "msgfolderroot"
        case archive = "archive"
        case junkEmail = "junkemail"
    }
}

