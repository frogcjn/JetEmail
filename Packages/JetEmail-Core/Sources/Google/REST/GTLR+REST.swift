//
//  Google+Request.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import Foundation
@preconcurrency import GoogleAPIClientForREST_Gmail
import JetEmail_Foundation

// MARK: - Microsoft.Context: Account-MailFolders API

public extension Session {
    var service: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = _gtmSession
        service.shouldFetchNextPages = true
        return service
    }
    
    private func getMailFolders() async throws -> [GoogleMailFolder] {
        let response = try await service.execute(GTLRGmail_ListLabelsResponse.self) {
            GTLRGmailQuery_UsersLabelsList.query(withUserId: accountID.innerID)
        }
        guard let labels = response.labels else { throw GmailApiError.failedToParseData(response) }
        return try labels.map { .init(self, data: try $0.mailFolderData) }
            //.sorted { "\($0.type?.rawValue)" > "\($1.type?.rawValue)" }
            //.filter { $0.type == .user || $0.path == "SPAM" || $0.path == "INBOX"}
            //.sorted(using: KeyPathComparator(\MailFolder.name))
    }
    
    func getMailFolderTree(rootElement: GoogleMailFolder) async throws -> Tree<GoogleMailFolder> {
        let tree = Tree(rootElement: rootElement)
        
        // copy name to path
        let elements = try await getMailFolders().map { var item = $0; item.data.path = $0.data.name; return item }
        var pathToNode = Dictionary(uniqueKeysWithValues: elements.compactMap { element in element.data.path.map { (path: $0, node: TreeNode(element: element)) } })
        // var pathToNode = [String : TreeNode<GoogleMailFolder>]()
        pathToNode[""] = tree.root
            
        for (key: path, value: node) in pathToNode.sorted(using: KeyPathComparator(\.key)) {
            if node.element.id == tree.root.element.id { continue }
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
            (node.parent, node.element.data.name) = (parent, name)
            parent.children.append(node)
        }
        
        return tree
    }
    
    func getMessages(id mailFolderID: GoogleMailFolderID) async throws -> [GoogleMessage] {
        let ids: [GoogleMessageID] = try await getFolderMessageIDs(id: mailFolderID).map { .init(accountID: mailFolderID.accountID,  innerID: $0.id) }
        return try await getMessages(ids: ids, format: .metadata).map { .init(self, data: $0) }
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    private func getFolderMessageIDs(id: GoogleMailFolderID) async throws -> [GoogleMessageData] {
        let response = try await service.execute(GTLRGmail_ListMessagesResponse.self) {
            let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: accountID.innerID)
            query.labelIds = [id.innerID]
            query.maxResults = 500
            return query
        }
        
        guard let messages = response.messages else { throw GmailApiError.failedToParseData(response) }
        return try messages.map{ try $0.messageData }
    }

    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    private func getMessages(ids: [GoogleMessageID], fields: String? = nil, format: GetMessageFormat) async throws -> [GoogleMessageData] {
        if ids.count > 100 {
            let first100 = ids.prefix(100)
            let rest = ids.dropFirst(100)
            let result = try await getMessages(ids: Array(first100), fields: fields, format: format) + getMessages(ids: Array(rest), fields: fields, format: format)
            return result
        }
        
        let batchResult = try await service.execute(GTLRBatchResult.self) {
            GTLRBatchQuery(queries: ids.map { [accountID = accountID.innerID] in
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
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    func getMessage(id: GoogleMessageID, fields: String? = nil, format: GetMessageFormat) async throws -> GoogleMessageData {
         try await service.execute(GTLRGmail_Message.self) {
            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID.innerID, identifier: id.innerID)
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
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/modify
    func moveMessage(id messageID: GoogleMessageID, from fromID: GoogleMailFolderID, to toID: GoogleMailFolderID) async throws -> GoogleMessageData {
        try await service.execute(GTLRGmail_Message.self) {
            let accountID = accountID.innerID
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

extension Session {
    
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
