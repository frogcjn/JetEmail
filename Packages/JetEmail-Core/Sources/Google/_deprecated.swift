//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//


/*
// MARK: - Convenience
extension MailFolder {
    init?(gtlrGmailLabel: GTLRGmail_Label) {
        /*guard let name = gmailFolder.name else { return nil }
        guard let id = gmailFolder.identifier else {
            assertionFailure("Gmail folder \(gmailFolder) doesn't have identifier")
            return nil
        }
        // folder.identifier is missing for hidden GTLRGmail_Labels
        if path.isEmpty {
            return nil
        }

        if GeneralConstants.Gmail.standardGmailPaths.contains(path) {
            name = "folder_\(name.replacingOccurrences(of: " ", with: "_"))"
        }*/
        
       
       //  let image: Data?
        // let backgroundColor: String? //?
        //let isHidden: Bool? //?
        //var itemType: String? = FolderViewModel.ItemType.folder.rawValue //?
        
    }
}

 init(path: String, name: String, image: Data? = nil, backgroundColor: String? = nil, isHidden: Bool? = nil, itemType: String? = nil) {
     self.path = path
     self.name = name
     self.image = image
     self.backgroundColor = backgroundColor
     self.isHidden = isHidden
     self.itemType = itemType
 }
 
*/

/*
@MainActor
public extension Session {
    static subscript(id: ID) -> Session? {
        get {
            guard let session = SessionStore[id] else { return nil }
            return session
        }
        set { SessionStore[id] = newValue }
    }
}
*/



// GTMSession -> Keychain
/*
fileprivate extension GTMSession {
    func insertTo(keychain: Keychain) async throws -> Keychain.SessionItem {
        try await keychain.insertItem(gtmSession: self)
    }
}
*/

// Session -> Keychain


// KeyChain -> Session
/*
@MainActor
extension Keychain.SessionItem {
    var lazySession: Session {
        if let session = SessionStore.shared[accountID] {
            assert(session.keychainItem == keychainItem)
            return session
        }
        return newSession
    }
    
    var newSession: Session {
        let session = Session(accountID: accountID, username: username, gtmSession: gtmSession, keychainItem: keychainItem)
        SessionStore.shared[accountID]  = session
        return session
    }
    
    /*var lazyReplacementSession: Session {
        if let session = Session[id] {
            session.gtmSession = gtmSession
            assert(session.keychainItem === keychainItem)
            return session
        }
        return newSession
    }*/
    
}

*/
