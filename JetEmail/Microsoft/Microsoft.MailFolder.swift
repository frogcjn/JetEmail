//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

// MARK: - MailFolder

// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

extension Microsoft {
    struct MailFolder : Codable, Identifiable {
        let               id: ID
        let      displayName: String?
        let         isHidden: Bool?
        
        // parent-children relationship
        let   parentFolderId: ID?
        let childFolderCount: Int32?
        
        // mailFolder-messages relationship
        let  unreadItemCount: Int32?
        let   totalItemCount: Int32?
    }
}

extension Microsoft.MailFolder : Hashable {
    static func == (lhs: Microsoft.MailFolder, rhs: Microsoft.MailFolder) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: MailFolder.WellknownFolderName

extension Microsoft.MailFolder {
    // Well-known folder names https://learn.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0#methods
    
    enum WellKnownFolderName : String {
        case msgFolderRoot = "msgfolderroot"
        case archive = "archive"
        case junkEmail = "junkemail"
    }
}
