//
//  Google+Request.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import Foundation
import GoogleAPIClientForREST_Gmail
import JetEmail_Foundation

// MARK: - Microsoft.Context: Account-MailFolders API

public extension Google.Session {
    var service: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = gtmSession
        service.shouldFetchNextPages = true
        return service
    }
    
    func getMailFolders() async throws -> [Google.MailFolder] {
        try await service.execute {
            GTLRGmailQuery_UsersLabelsList.query(withUserId: accountID.string)
        } completion: { (object: GTLRGmail_ListLabelsResponse) in
            guard let labels = object.labels else { throw GmailApiError.failedToParseData(object) }
            return try labels
                .map { try $0.swift }
                // .filter { $0.type == .user || $0.path == "SPAM" || $0.path == "INBOX"}
        }
    }
    
    func getMailFolderTree(rootElement: Google.MailFolder) async throws -> Tree<Google.MailFolder> {
        let tree = Tree(rootElement: rootElement)
        let elements = try await getMailFolders()
        
        var pathToNode = Dictionary(uniqueKeysWithValues: elements.compactMap { element in element.path.map { (path: $0, node: TreeNode(element: element)) } })
        pathToNode[""] = tree.root
            
        for (key: path, value: node) in pathToNode.sorted(using: KeyPathComparator(\.key)) {
            if node.id == tree.root.id { continue }
            let components = path.components(separatedBy: "/")
            
            var (parent, name) = (tree.root, path)
            for lastComponentCount in 1..<components.count {
                let previousComponents = components.dropLast(lastComponentCount).joined(separator: "/") // try name component count
                let lastComponent = components.suffix(lastComponentCount).joined(separator: "/")
                if let node = pathToNode[previousComponents] { // find parent
                    (parent, name) = (node, lastComponent)
                    break
                }
            }
            (node.parent, node.name) = (parent, name)
            parent.children.append(node)
        }
        
        return tree
    }
    
    func getMessages(mailFolderID: Google.MailFolder.ID) async throws -> [Google.Message] {
        let ids = try await getFolderMessageIDs(mailFolderID: mailFolderID).map(\.id)
        return try await getMessages(ids: ids, format: .metadata)
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    private func getFolderMessageIDs(mailFolderID: Google.MailFolder.ID) async throws -> [Google.Message.ListItem] {
        try await service.execute {
            let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: accountID.string)
            query.labelIds = [mailFolderID.string]
            query.maxResults = 500
            return query
        } completion: { (object: GTLRGmail_ListMessagesResponse) in
            guard let messages = object.messages else { throw GmailApiError.failedToParseData(object) }
            return try messages.map{ try $0.swift.listItem }
        }
    }

    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    private func getMessages(ids: [Google.Message.ID], fields: String? = nil, format: GetMessageFormat) async throws -> [Google.Message] {
        if ids.count > 100 {
            let first100 = ids.prefix(100)
            let rest = ids.dropFirst(100)
            let result = try await getMessages(ids: Array(first100), fields: fields, format: format) + getMessages(ids: Array(rest), fields: fields, format: format)
            return result
        }
        
        return try await service.execute {
            GTLRBatchQuery(queries: ids.map { [accountID = accountID.string] in
                let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID, identifier: $0.string)
                query.fields = fields
                query.format = format.rawValue
                return query
            })
        } completion: { (batchResult: GTLRBatchResult) in
            if let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] {
                try messagesDict.values.map { try $0.swift }
            } else {
                fatalError()
            }
        }
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    func getMessage(id: Google.Message.ID, fields: String? = nil, format: GetMessageFormat) async throws -> Google.Message {
        try await service.execute{
            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: self.accountID.string, identifier: id.string)
            query.fields = fields
            query.format = format.rawValue
            return query
        } completion: { (result: GTLRGmail_Message) in
            try result.swift
        }
        
        /*try await getItem("messages", "\(microsoftID)", queryItems: [
            .select(
                "id",
                "subject",
                "createdDateTime",
                "lastModifiedDateTime",
                "receivedDateTime",
                "sentDateTime",
                "sender",
                "from",
                "toRecipients",
                "replyTo",
                "ccRecipients",
                "bccRecipients",
                "bodyPreview",
                "body"
                // "uniqueBody"
            )
        ])*/
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/modify
    func moveMessage(id messageID: Google.Message.ID, from fromID: Google.MailFolder.ID, to toID: Google.MailFolder.ID) async throws -> Google.Message {
        try await service.execute{
            let accountID = self.accountID.string
            let messageID = messageID.string
            
            let request = GTLRGmail_ModifyMessageRequest()
            request.removeLabelIds =  [fromID.string]
            request.addLabelIds = [toID.string]
            
            let query = GTLRGmailQuery_UsersMessagesModify.query(withObject: request, userId: accountID, identifier: messageID)
            return query
        } completion: { (result: GTLRGmail_Message) in
            try result.swift
        }
    }
    
    enum GetMessageFormat: String {
        case raw
        case full
        case metadata
        case minimal
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    /*func getMessages(mailFolderID: Google.MailFolder.ID) async throws -> [Google.Message] {
        try await getItems("mailFolders", "\(microsoftID)", "messages", queryItems: [
            .orderBy(name: "receivedDateTime", .descending),
            .select(
                "id",
                "subject",
                "createdDateTime",
                "lastModifiedDateTime",
                "receivedDateTime",
                "sentDateTime",
                "sender",
                "from",
                "toRecipients",
                "replyTo",
                "ccRecipients",
                "bccRecipients",
                "bodyPreview"
            )
        ])
    }*/
}

extension GTLRGmailService {
    func execute<Q: GTLRQueryProtocol, T: NSObject, Result>(query: () -> Q, type: T.Type = T.self, completion: @escaping (T) async throws -> Result) async throws -> Result {
        try await withCheckedThrowingContinuation { continuation in
            executeQuery(query()) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let error { return continuation.resume(throwing: GmailApiError.convert(from: error as NSError)) }
                guard let result = object as? T else { return continuation.resume(throwing: AppErr.cast(T.description())) }
                Task {
                    do { continuation.resume(returning: try await completion(result)) }
                    catch { continuation.resume(throwing: error) }
                }
            }
        }
    }
}


// import GoogleAPIClientForREST_Gmail
/*extension Google.Client {
    func loadAccountMailFolders() async {
        
            [service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRGmail_ListLabelsResponse *response, NSError *error) {
                if (error == nil) {
                    completion(response.labels, nil);
                } else {
                    completion(nil, error);
                }
            }];
    }
}*/

extension Google.Session {
    
}

enum GeneralConstants {
    enum Gmail {
        static let clientID = "679326713487-5r16ir2f57bpmuh2d6dal1bcm9m1ffqc.apps.googleusercontent.com"
        static let redirectURL = URL(string: "com.googleusercontent.apps.679326713487-5r16ir2f57bpmuh2d6dal1bcm9m1ffqc:/oauthredirect")!
        //static let mailScope: [GoogleScope] = [.userInfo, .userEmail, .mail]
        //static let contactsScope: [GoogleScope] = mailScope + [.contacts, .otherContacts]
        static let trashLabelPath = "TRASH"
        // Empty pass is For All MAIL
        static let standardGmailPaths = ["INBOX", "CHAT", "SENT", "IMPORTANT", trashLabelPath, "DRAFT", "SPAM", "STARRED", "UNREAD", ""]
        static let gmailRecoveryEmailSubjects = [
            "Your FlowCrypt Backup",
            "Your CryptUp Backup",
            "All you need to know about CryptUP (contains a backup)",
            "CryptUP Account Backup"
        ]
    }

    enum Global {
        static let attachmentSizeLimit = 10_000_000
        static let signatureSeparator = "______"
    }

    enum Mock {
        static let backendUrl = "https://127.0.0.1:8001"
        static let userEmail = "e2e.enterprise.test@flowcrypt.com"
    }

    enum EmailConstant {
        static let recoverAccountSearchSubject = [
            "Your FlowCrypt Backup",
            "Your CryptUp Backup",
            "Your CryptUP Backup",
            "CryptUP Account Backup",
            "All you need to know about CryptUP (contains a backup)"
        ]
    }
}


struct FolderViewModel {
    enum ItemType: String {
        case folder, settings, separator, logOut
    }
}
