//
//  Google+Message+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

/*set {
    guard let google = newValue else { return }
    
    
    
    self.modelID      = google.modelID
    self.subject      = headerValue(name: "Subject")
    
    /*self.createdDate  = graph.createdDateTime?     .date
    self.modifiedDate = graph.lastModifiedDateTime?.date*/
    //self.receivedDate = headerValue(name: "Date")?.rfc2822
    self.receivedDate = google.internalDate?.milliSecondsTimeIntervalSince1970
    self.date         = self.receivedDate
    //self.sentDate     = headerValue(name: "Date")?.rfc2822
    
    //self.sender       = graph.sender?.emailAddress
    self.from         = headerValue(name: "From")
    //self.to           = graph.toRecipients? .compactMap(\.emailAddress).nilIfEmpty
    //self.replyTo      = graph.replyTo?      .compactMap(\.emailAddress).nilIfEmpty
    ////self.cc           = graph.ccRecipients? .compactMap(\.emailAddress).nilIfEmpty
    // self.bcc          = graph.bccRecipients?.compactMap(\.emailAddress).nilIfEmpty
    
    self.bodyPreview  = google.snippet
    
    
    let firstPart = google.payload?.parts?.first { $0.partID == "1" }
    let firstPartMIME = firstPart?.mimeType
    let firstPartString = try? firstPart?.body?.data?.string
    print(firstPartMIME ?? "nil", firstPartString ?? "nil")
    
    if firstPartMIME == "text/html" {
        self.body  =  .init(content: firstPartString, contentType: .html)
    } else if firstPartMIME == "text/plain" {
        self.body  =  .init(content: firstPartString, contentType: .text)
    } else if firstPartMIME == nil {
        () // self.body  =
    } else {
        fatalError()
    }
    // print(#function, google.payload?.body?.data ?? "nil")
    /*self.uniqueBody   = graph.uniqueBody*/

    self._google = try? google.jsonString
}*/

/*let firstPart = google.payload?.parts?.first { $0.partID == "1" }
let firstPartMIME = firstPart?.mimeType
let firstPartString = try? firstPart?.body?.data?.string
print(firstPartMIME ?? "nil", firstPartString ?? "nil")

if firstPartMIME == "text/html" {
    self.body  =  .init(content: firstPartString, contentType: .html)
} else if firstPartMIME == "text/plain" {
    self.body  =  .init(content: firstPartString, contentType: .text)
} else if firstPartMIME == nil {
    () // self.body  =
} else {
    fatalError()
}*/

/*
 MessageBody
   - text : ""
   - html : nil
   - attachment : nil
 */


/*
    attachments
 */
/*let attachmentsIds = payload.parts?.compactMap { $0.body?.attachmentId } ?? []
var attachments = google.parseAttachments()
if body.hasNoContent, let bodyPartAttachment = google.parseBodyPartAttachment() {
    attachments.append(bodyPartAttachment)
}*/

//self.body = body
// self.size = google.sizeEstimate.flatMap(Int.init)
// self.label = labels
// self.attachmentIds = attachmentIds
// self.attachments = attachments
//self.threadID = google.threadId
//self.rfcu22MegId = rfc822MsgId
//self.raw = google.raw

/*self.init(
    identifier: Identifier(stringId: identifier),
    // convert miliseconds to seconds
    date: Date(timeIntervalSince1970: internalDate / 1000),
    sender: sender,
    subject: subject,
    size: gmailMessage.sizeEstimate.flatMap(Int.init),
    labels: labels,
    attachmentIds: attachmentsIds,
    body: body,
    attachments: attachments,
    threadId: gmailMessage.threadId,
    rfc822MsgId: rfc822MsgId,
    raw: gmailMessage.raw,
    to: to,
    cc: cc,
    bcc: bcc,
    replyTo: replyTo,
    inReplyTo: inReplyTo
)*/




// Gmail string extension identifier




/*
fileprivate extension Google.Message.Full {
var attachmentParts: [Google.Message.Part] {
payload?.parts?.filter { !$0.filename.isEmptyOrNil } ?? []
}

func parseBodyAttachment() -> MessageAttachment? {
guard let part = payload?.body,
      let attachmentId = part.attachmentId
else { return nil }

return MessageAttachment(
    id: attachmentId,
    name: "body",
    estimatedSize: part.size,
    mimeType: "text/plain"
)
}

func parseAttachments() -> [MessageAttachment] {
attachmentParts.compactMap { (part: Google.Message.Part) -> MessageAttachment? in
    guard let body = part.body, let id = body.attachmentId, let name = part.filename
    else { return nil }

    return MessageAttachment(
        id: id,
        name: name,
        estimatedSize: body.size,
        mimeType: part.mimeType,
        data: body.data
    )
}
}

func parseBodyPartAttachment() -> MessageAttachment? {
guard let body = payload?.parts?.first(where: { $0.mimeType == "text/plain" })?.body,
      let attachmentId = body.attachmentId
else { return nil }

return MessageAttachment(
    id: attachmentId,
    name: "encrypted.asc",
    estimatedSize: body.size,
    mimeType: "text/plain"
)
}
}

fileprivate extension MessageBody {
var hasNoContent: Bool {
text.isEmpty && attachment == nil
}
}

fileprivate extension Optional where Wrapped: Collection {
var isEmptyOrNil: Bool {
 self?.isEmpty ?? true
}
}


struct MessageAttachment: Equatable, Hashable, FileType {
let id           : String
let name         : String
let estimatedSize: Int?
let mimeType     : String?

var treatAs      : String?
var data         : Data?
}


protocol FileType {
var name         : String  { get }
var estimatedSize: Int?    { get }
var mimeType     : String? { get }

var treatAs      : String? { get set }
var data         : Data?   { get set }
}

*/
/*
 enum HeaderFieldValue {
     
     // mailbox-list
     struct From: RawRepresentable {
         let rawValue: String
     }
     
     // mailbox
     struct Sender: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct ReplyTo: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct To: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct CC: RawRepresentable {
         let rawValue: String
     }
     
     // address-list / CFWS
     struct BCC: RawRepresentable {
         let rawValue: String
     }
     
     // mailSpec
     struct DeliveredTo: RawRepresentable {
         let rawValue: String
     }
 }

 extension String {
     var headerValueFrom       : HeaderFieldValue.From        { .init(rawValue: self) }
     var headerValueSender     : HeaderFieldValue.Sender      { .init(rawValue: self) }
     var headerValueReplyTo    : HeaderFieldValue.ReplyTo     { .init(rawValue: self) }
     var headerValueTo         : HeaderFieldValue.To          { .init(rawValue: self) }
     var headerValueCC         : HeaderFieldValue.CC          { .init(rawValue: self) }
     var headerValueBCC        : HeaderFieldValue.BCC         { .init(rawValue: self) }
     var headerValueDeliveredTo: HeaderFieldValue.DeliveredTo { .init(rawValue: self) }
 }

 */

// MARK: - AppModel: Account Status
/*
extension AppItemModel<Account> {
    
    var _hasAccount: Bool {
        get async {
            switch item.modelID.enumValue {
            case .microsoft(let id):
                (try? await microsoftClient.account(id: id)) != nil
            case .google(let id):
                (try? await    googleClient.account(id: id)) != nil
            }
        }
    }
    
    var _hasSession: Bool {
        get async throws {
            switch item.modelID.enumValue {
            case .microsoft(let id):
                try await microsoftClient.hasSession(id: id)
            case .google(let id):
                try await googleClient.hasSession(id: id)
            }
        }
    }*/
    
    /*func updateState() async {
        do {
            print("AppItemModel.updateState")
            item.hasAccount = await _hasAccount
            item.hasSession = try await _hasSession
            print(item.state)
        } catch {
            logger.debug("\(error)")
        }
    }
}
     */








/*fileprivate extension AppModel {
    func graphContext(graphID: MicrosoftAPI.Account.ID) async throws -> CombineContext<MicrosoftAPI, MicrosoftAPI.Account> {
        let graphClient = try await MicrosoftAPI.shared
        return .init(context: graphClient, item: try graphClient.account(graphID: graphID))
    }
}*/



/*func syncFolderTree() async throws {
    guard !self.isLoadingFolderTree else { return }
    self.isLoadingFolderTree = true
    defer { self.isLoadingFolderTree = false }
    
    
    let root  = TargetFolderPaths.sharedTree.root
    let rootFolder = try await self.mailFoldersRequest.getMailFolder(wellKnownFolderName: .msgFolderRoot)
    
    var queue: [(TreeNode<FolderName>, MailFolder)] = [(root, rootFolder)]
    while !queue.isEmpty {
        let (parent, parentFolder) = queue.removeFirst()
        print("<checking: \(parentFolder.displayName)>")
        for child in parent.children {
            let childName = child.element
            var childFolder: MailFolder
            
            switch childName {
            case .special(let specialName):
                childFolder = try await self.mailFoldersRequest.getMailFolder(wellKnownFolderName: specialName.graph)
                // verified existed
                assert(childFolder.parentFolderId == parentFolder.id)
                print("    <exists: \(childFolder.displayName)/>")
            case .display(let displayName):
                let childFolders = try await self.mailFoldersRequest.getChildFolders(id: parentFolder.id)
                if let mailFolder = childFolders.first(where: { $0.displayName == displayName }) {
                    childFolder = mailFolder
                } else {
                    childFolder = try await self.mailFoldersRequest.createChildFolder(id: parentFolder.id, displayName: displayName)
                }
                print("    <created: \(childFolder.displayName)/>")
            }
            queue.append((child, childFolder))
        }
        print("</checking: \(parentFolder.displayName)>")
    }
    
    // var queue: [TreeNode<String>] = [root]
            
    /*while !queue.isEmpty {
        
    }*/
}*/

/*
 
 import MimeEmailParser

 struct MailBox : Codable, Equatable {
     let    addrSpec: String
     let displayName: String?
 }

 extension MailBox {
     var rawValue: String {
         if let displayName { "\(displayName) <\(addrSpec)>" }
         else { addrSpec }
     }
 }

 extension String {
     var paringAddressList: [MailBox] { get throws {
         try MimeEmailParser().parseAddressList(addresses: self).map(\.mailbox)
     } }
     
     var parsingAddress: MailBox { get throws {
         try MimeEmailParser().parseSingleAddress(address: self).mailbox
     } }
 }

 extension Address {
     var mailbox: MailBox {
         .init(addrSpec: Address, displayName: Name)
     }
 }


 */
/*
extension Address {
    init(rawValue: String) {
        //guard let address = MCOAddress(nonEncodedRFC822String: string) else {
        /*let b = try! MimeEmailParser().parseAddressList(addresses: rawValue)
            self.name = nil
            self.email = string
            return
         //}*/
        self.name = ""  //address.displayName
        self.email = "" //address.mailbox
    }
}*/
/*
extension Microsoft.EmailAddress {
    var recipient: Address {
        Address(email: address!, name: name)
    }
}
 
 extension Microsoft.EmailAddress {
     var mailbox: MailBox {
         .init(addrSpec: address, displayName: name)
     }
 }
*/



// Microsoft.MSALAccount -> MSALSession
/*extension Microsoft.MSALAccount {
    func msalSession(client: Microsoft.Client) async throws -> Microsoft.MSALSession {
        try await client._msalRefresh(msalAccount: self)
    }
}*/
/*
extension Microsoft.ID {
    var refreshSession: Microsoft.MSALSession {
        get async throws {
            let client = try await Microsoft.Client.shared
            return try await client._msalClient.account(forIdentifier: string).refreshMSALSession
        }
    }
}*/


    
    /*var lazyMSALSession: Microsoft.MSALSession {
        get async throws {
            if let session = try Microsoft.MSALSession[self] { return session }
            return  try await refreshMSALSession
        }
    }*/

/*
extension Microsoft.MSALSession {
    var refresh: Microsoft.MSALSession {
        get async throws {
            try await account._msalRefreshMSALSession
        }
    }
}
*/

/*extension Microsoft.Session {
    var refresh: Microsoft.Session { get async throws {
        _msalSession = try await _msalSession.refresh
        return self
    } }
}*/

/*
 //
 //  GoogleAPI.Account.swift
 //  JetEmail
 //
 //  Created by Cao, Jiannan on 2/17/24.
 //

 import Security
 import Google

 /*
 Google.Session = Google.Account + GTMAuthSession
 */
 /*
 extension Google {
     class Session: SessionProtocol {
                 let  accountID         : Google.ID
                 let  username   : String
                 let  gtmSession : GTMSession
         // { didSet { if gtmSession != oldValue { Task { _ = try await updateKeychainItem() } } } }
           
                 let keychainItem: SecKeychainItem
          
         
         init(accountID: Google.ID, username: String, gtmSession: GTMSession, keychainItem: SecKeychainItem) {
             self.accountID    = accountID
             self.username     = username
             self.gtmSession   = gtmSession
             self.keychainItem = keychainItem
             super.init()
             
             gtmSession.delegate = self
             gtmSession.authState.stateChangeDelegate = self
             gtmSession.authState.errorDelegate = self
         }
         
         func additionalTokenRefreshParameters(forAuthSession gtmSession: GTMSession) -> [String : String]? {
             return nil
         }
         
         func updateError(forAuthSession gtmSession: GTMSession, originalError: Error, completion: @escaping (Error?) -> Void) {
             completion(originalError)
         }
         
         func didChange(_ state: OpenIDState) {
             Task { _ = try await updateKeychainItem() }
         }
         
         func authState(_ state: OpenIDState, didEncounterAuthorizationError error: Error) {
             print(#function, state)
         }
         
         func authState(_ state: OpenIDState, didEncounterTransientError error: Error) {
             print(#function, state)
         }
         
         fileprivate func updateKeychainItem() async throws {
             _ = try await Google.Client.shared.keychain.updateItem(item)
         }
         
         func refresh() async throws {
             _ = try await gtmSession.refresh()
         }
     }
 }




 // Google.GTMSession -> Google.SessionKeychain.Item
 extension Google.GTMSession {
     func insertTo(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
         try await keychain.insertItem(gtmSession: self)
     }
     
     
 }


 extension Google.Keychain.SessionItem {
     
     func deleteFrom(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
         try await keychain.deleteItem(self)
     }
 }
*/*/
