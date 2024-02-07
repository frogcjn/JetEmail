//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import MSAL

struct Microsoft {
    struct Graph {
        
    }
}

// MARK: - MailFolder

// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

extension Microsoft.Graph {
    struct MailFolder : Codable, Identifiable {
        let               id: ID
        let      displayName: String
        let         isHidden: Bool
        
        // mail items
        let  unreadItemCount: Int32
        let   totalItemCount: Int32
        
        // mail folder tree node
        let   parentFolderId: ID
        let childFolderCount: Int32
        
        struct ID : RawRepresentable, Codable, Hashable {
            let rawValue: String
        }
    }
}

extension Microsoft.Graph.MailFolder : Hashable {
    static func == (lhs: Microsoft.Graph.MailFolder, rhs: Microsoft.Graph.MailFolder) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

