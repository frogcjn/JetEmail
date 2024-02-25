//
//  Google+Request.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import GoogleAPIClientForREST_Gmail

// MARK: - Microsoft.Context: Account-MailFolders API

extension Google.Session {
    var service: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = gtmSession
        service.shouldFetchNextPages = true
        return service
    }
    
    func getMailFolders() async throws -> [Google.MailFolder] {
        let query = GTLRGmailQuery_UsersLabelsList.query(withUserId: accountID.string)
        return try await service.execute(query: query, type: GTLRGmail_ListLabelsResponse.self) { object in
            guard let labels = object.labels else { throw GmailApiError.failedToParseData(object) }
            
            let result: [Google.MailFolder] = labels
                .compactMap { $0 }
                .compactMap(Google.MailFolder.init(gtlrGmailLabel:))
                .filter { $0.type == .user }
            
            return result
        }
    }
    
    
    func getMessages(mailFolderID: Google.MailFolder.ID) async throws -> [Google.Message] {
        try await getMessages(ids: getMessageIDs(mailFolderID: mailFolderID).map(\.id))
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    private func getMessageIDs(mailFolderID: Google.MailFolder.ID) async throws -> [(id: Google.Message.ID, threadID: String?)] {
        let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: accountID.string)
        query.labelIds = [mailFolderID.string]
        return try await service.execute(query: query) { (object: GTLRGmail_ListMessagesResponse) in
            guard let messages = object.messages else { throw GmailApiError.failedToParseData(object) }
            let ids: [(id: Google.Message.ID, threadID: String?)] = messages
                    .compactMap { item in item.identifier.map{ (id: .init(string: $0), threadID: item.threadId) } }
            return ids
        }
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    private func getMessages(ids: [Google.Message.ID]) async throws -> [Google.Message] {
        let query = GTLRBatchQuery(queries: ids.map { [accountID = accountID.string] in
            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID, identifier: $0.string)
            query.fields = "id, snippet, payload(headers), internalDate"
            return query
        })
        return try await service.execute(query: query){ (batchResult: GTLRBatchResult) in
            if let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] {
                try messagesDict.values.map { try $0.swift }
            } else {
                fatalError()
            }
        }
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    func getMessageBody(id: Google.Message.ID) async throws -> Google.Message {
        let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: self.accountID.string, identifier: id.string)
        //query.fields = "id, snippet, payload(headers), payload(body), internalDate"
        query.format = "full"

        return try await service.execute(query: query) { (result: GTLRGmail_Message) in
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
    func execute<Q: GTLRQueryProtocol, T: NSObject, Result>(query: Q, type: T.Type = T.self, completion: @escaping (T) async throws -> Result) async throws -> Result {
        try await withCheckedThrowingContinuation { continuation in
            executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let error { return continuation.resume(throwing: GmailApiError.convert(from: error as NSError)) }
                guard let result = object as? T else { return continuation.resume(throwing: AppErr.cast(T.description())) }
                Task {
                    do {
                        continuation.resume(returning: try await completion(result))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}


import GoogleAPIClientForREST_Gmail
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

