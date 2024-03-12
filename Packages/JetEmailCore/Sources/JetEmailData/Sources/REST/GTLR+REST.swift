//
//  Google+Request.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import Foundation
@preconcurrency import GoogleAPIClientForREST_Gmail
import JetEmailFoundation // for Tree
import JetEmailID
import JetEmailGoogle

// MARK: - Microsoft.Context: Account-MailFolders API

public extension GoogleSession {
    var service: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = _gtmSession
        service.shouldFetchNextPages = true
        return service
    }
    
    
    private func getMailFolders() async throws -> [GoogleMailFolder] {
        let response = try await service.execute(GTLRGmail_ListLabelsResponse.self) {
            GTLRGmailQuery_UsersLabelsList.query(withUserId: account.id.innerID)
        }
        guard let labels = response.labels else { throw GmailApiError.failedToParseData(response) }
        return try labels.map { try $0.mailFolder.with(accountID: account.id, systemInfo: $0.mailFolder.systemInfo) }
            //.sorted { "\($0.type?.rawValue)" > "\($1.type?.rawValue)" }
            //.filter { $0.type == .user || $0.path == "SPAM" || $0.path == "INBOX"}
            //.sorted(using: KeyPathComparator(\MailFolder.name))
    }
    
    // google mailfolder path-name algrithm
    func getMailFolderTree(rootElement: GoogleMailFolder) async throws -> Tree<GoogleMailFolder> {
        let tree = Tree(rootElement: rootElement)
        
        // copy name to path
        let elements = try await getMailFolders()
        var pathToNode = Dictionary(uniqueKeysWithValues: elements.compactMap { element in element.path.map { (path: $0, node: TreeNode(element: element)) } })
        // var pathToNode = [String : TreeNode<GoogleMailFolder>]()
        pathToNode[""] = tree.root
            
        for (key: path, value: node) in pathToNode.sorted(using: KeyPathComparator(\.key)) {
            if node.element.id == tree.root.element.id { continue }
            let components = path.components(separatedBy: "/")
            
            var (parent, processedName) = (tree.root, path)
            for lastComponentCount in 1..<components.count {
                let previousComponents = components.dropLast(lastComponentCount).joined(separator: "/") // try name component count
                let lastComponent = components.suffix(lastComponentCount).joined(separator: "/")
                if let node = pathToNode[previousComponents] { // find parent
                    (parent, processedName) = (node, lastComponent)
                    break
                }
            }
            (node.parent, node.element) = (parent, node.element.with(systemInfo: node.element.systemInfo, processedName: processedName))
            parent.children.append(node)
        }
        
        return tree
    }
    

    
    func getMessages(ids: [GoogleMessageID]) async throws -> [GoogleMessage] {
        return try await getMessages(ids: ids, format: .metadata).map { try $0.with(accountID: account.id) }
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    private func getFolderMessageIDs(id: GoogleMailFolderID) async throws -> [GoogleMessageInner] {
        let response = try await service.execute(GTLRGmail_ListMessagesResponse.self) {
            let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: account.id.innerID)
            query.labelIds = [id.innerID]
            query.maxResults = 500
            return query
        }
        
        guard let messages = response.messages else { throw GmailApiError.failedToParseData(response) }
        return try messages.map{ try $0.messageData }
    }
    
    // pageSize => $top: 1-1000, default: 1000
    func xxxgetMessagesID(in mailFolderID: GoogleMailFolderID, pageSize: Int? = 1000) async throws -> [GoogleMessageID] {
        let ids: [GoogleMessageID] = try await getFolderMessageIDs(id: mailFolderID).map { .init(accountID: mailFolderID.accountID,  innerID: $0.id) }
        return ids
    }

    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    private func getMessages(ids: [GoogleMessageID], fields: String? = nil, format: GetMessageFormat) async throws -> [GoogleMessageInner] {
        if ids.count > 100 {
            let first100 = ids.prefix(100)
            let rest = ids.dropFirst(100)
            let result = try await getMessages(ids: Array(first100), fields: fields, format: format) + getMessages(ids: Array(rest), fields: fields, format: format)
            return result
        }
        
        let batchResult = try await service.execute(GTLRBatchResult.self) {
            GTLRBatchQuery(queries: ids.map { [accountID = account.id.innerID] in
                let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID, identifier: $0.innerID)
                query.fields = fields
                query.format = format.rawValue
                return query
            })
        }
        
        return if let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] {
            try messagesDict.values.map { try $0.messageData }
        } else {
            fatalError()
        }
    }
    
    func getMessagesStream(ids: [GoogleMessageID], fields: String? = nil, format: GetMessageFormat) async throws -> AsyncThrowingStream<[GoogleMessage], Error> {
        .init { continuation in Task { [service] in
            do {
                let chunkSize = 10
                var rest = ids[...]
                
                while rest.count > 0 {
                    let chunk = rest.prefix(chunkSize)
                    rest = rest.dropFirst(chunkSize)
                    
                    let batchResult = try await service.execute(GTLRBatchResult.self) {
                        GTLRBatchQuery(queries: chunk.map { [accountID = account.id.innerID] in
                            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID, identifier: $0.innerID)
                            query.fields = fields
                            query.format = format.rawValue
                            return query
                        })
                    }
                    
                    guard let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] else { fatalError() } // TODO: fatalError replace with error
                    let result: [GoogleMessage] = try messagesDict.values.map { try $0.messageData.with(accountID: account.id) }
                    
                    continuation.yield(result)
                    await Task.yield()
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    func getMessage(id: GoogleMessageID, fields: String? = nil, format: GetMessageFormat) async throws -> GoogleMessageInner {
         try await service.execute(GTLRGmail_Message.self) {
             let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: account.id.innerID, identifier: id.innerID)
            query.fields = fields
            query.format = format.rawValue
            return query
        }.messageData
        
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
    
    func getMessageBody(id: GoogleMessageID) async throws -> GoogleMessage {
        let full = try await getMessage(id: id, format: .full)
        let raw  = try await getMessage(id: id, format: .raw).raw
        return try full.with(accountID: account.id, raw: raw)
    }
    
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/modify
    func moveMessage(id messageID: GoogleMessageID, from fromID: GoogleMailFolderID, to toID: GoogleMailFolderID) async throws -> GoogleMessageInner {
        try await service.execute(GTLRGmail_Message.self) {
            let accountID = account.id.innerID
            let messageID = messageID.innerID
            
            let request = GTLRGmail_ModifyMessageRequest()
            request.removeLabelIds =  [fromID.innerID]
            request.addLabelIds = [toID.innerID]
            
            let query = GTLRGmailQuery_UsersMessagesModify.query(withObject: request, userId: accountID, identifier: messageID)
            return query
        }.messageData
    }
    
    enum GetMessageFormat: String, Sendable {
        case raw
        case full
        case metadata
        case minimal
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    /*func getMessages(mailFolderID: MailFolder.ID) async throws -> [Message] {
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
    func execute<Q: GTLRQueryProtocol, T: NSObject & Sendable>( _ type: T.Type = T.self, query: () -> Q) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            executeQuery(query()) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let error { return continuation.resume(throwing: GmailApiError.convert(from: error as NSError)) }
                guard let result = object as? T else { return continuation.resume(throwing: AppErr.cast(T.description())) }
                Task {
                    continuation.resume(returning: result)
                }
            }
        }
    }
}


// import GoogleAPIClientForREST_Gmail
/*extension Client {
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

extension GoogleSession {
    
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

extension GoogleMessageInner {
    func with(accountID: GoogleAccountID, raw: Data? = nil) throws -> GoogleMessage {
        try .init(id: .init(accountID: accountID, innerID: id), inner: self, raw: raw)
    }
}
