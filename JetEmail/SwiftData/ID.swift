//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import SwiftData

// MARK: - Model + StringID

/*extension Account : Hashable, Equatable, Identifiable {
    typealias ID = String
    // var id: String { id }
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        lhs.modelID == rhs.modelID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelID)
    }
}*/

extension MailFolder : Hashable, Equatable, Identifiable {
    // var id: String { id }

    static func ==(lhs: MailFolder, rhs: MailFolder) -> Bool {
        lhs.persistentModelID == rhs.persistentModelID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(persistentModelID)
    }
}

extension Message : Hashable, Equatable, Identifiable {
    // var id: String { id }

    static func ==(lhs: Message, rhs: Message) -> Bool {
        lhs.persistentModelID == rhs.persistentModelID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(persistentModelID)
    }
}




extension Account {
    struct ModelID: ModelIDProtocol {
        let platform: Platform
        let platformID: String
    }
}

extension MailFolder {
    struct ModelID: ModelIDProtocol {
        let platform: Platform
        let platformID: String
    }
}

extension Message {
    struct ModelID: ModelIDProtocol {
        let platform: Platform
        let platformID: String
    }
}

protocol ModelIDProtocol: StringID {
    var platform: Platform { get }
    var platformID: String { get }
}

extension ModelIDProtocol {
    var string: String { "\(platform.rawValue)/\(platformID)" }
    init(string: String) throws { fatalError() }
}

struct PersistentID<Model : PersistentModel> {
    let rawValue: PersistentIdentifier
}

extension PersistentModel {
    var persistentID: PersistentID<Self> {
        .init(rawValue: persistentModelID)
    }
}


enum Platform : String, Codable {
    case microsoft
    case google
}

extension Account.ModelID {

    enum Enum : Codable {
        case microsoft(Microsoft.Account.ID)
        case google(Google.Account.ID)
    }
    
    var enumValue: Enum {
        switch platform {
        case .microsoft: .microsoft(.init(string: platformID))
        case .google   : .google   (.init(string: platformID))
        }
    }
    
    init(enumValue: Enum) {
        (platform, platformID) = switch enumValue {
        case .microsoft(let platformID): (.microsoft, platformID.string)
        case .google   (let platformID): (.google   , platformID.string)
        }
    }
}

extension MailFolder.ModelID {

    enum Enum : Codable {
        case microsoft(Microsoft.MailFolder.ID)
        //case google(Google.MailFolder.ID)
    }
    
    var enumValue: Enum {
        switch platform {
        case .microsoft: .microsoft(.init(string: platformID))
        case .google: fatalError()
        //case .google   : .google   (.init(string: platformID))
        }
    }
    
    init(enumValue: Enum) {
        (platform, platformID) = switch enumValue {
        case .microsoft(let platformID): (.microsoft, platformID.string)
        //case .google   (let platformID): (.google   , platformID.string)
        }
    }
}

extension Message.ModelID {

    enum Enum : Codable {
        case microsoft(Microsoft.Message.ID)
        //case google(Google.Message.ID)
    }
    
    var enumValue: Enum {
        switch platform {
        case .microsoft: .microsoft(.init(string: platformID))
        case  .google: fatalError()
        //case .google   : .google   (.init(string: platformID))
        }
    }
    
    init(enumValue: Enum) {
        (platform, platformID) = switch enumValue {
        case .microsoft(let platformID): (.microsoft, platformID.string)
        //case .google   (let platformID): (.google   , platformID.string)
        }
    }
}









/*extension MailFolder {
    public struct ModelID : StringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}*/

/*extension Message {
    public struct ModelID : StringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}*/

// MARK: - Microsoft.Account.ID

extension Microsoft.Account {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}

extension Microsoft.MailFolder {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}

extension Microsoft.Message {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}
// MARK: - Google.Account.ID

extension Google.Account {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}


// MARK: - MSGraph.Account + Identifiable

/*
extension MSGraph.Account : Identifiable {
    public var id: ID {
        ID(rawValue: identifier ?? "")
    }
}
*/

// MARK: Microsoft -> Microsoft.Account.ID

extension Microsoft.MSALAccount {
    var id: Microsoft.Account.ID {
        get throws {
            guard let stringID = identifier else { throw Microsoft.AuthError.accountNoIDOrUsername }
            return .init(string: stringID)
        }
    }
}

extension Microsoft.MSALSession {
    var id: Microsoft.Account.ID { get throws { try account.id } }
}


// MARK: Google -> Google.Account.ID

extension Google.GTMAuthSession {
    var id: Google.Account.ID {
        get throws {
            guard let stringID = userID else { throw Google.AuthError.accountNoIDOrUsername }
            return .init(string: stringID)
        }
    }
}

// MARK: - Microsoft -> Account.ModelID

extension Microsoft.Account.ID {
    var modelID: Account.ModelID {
        .init(platform: .microsoft, platformID: string)
    }
}

extension Microsoft.Account {
    var modelID: Account.ModelID { id.modelID }
}

extension Microsoft.MSALAccount {
    var modelID: Account.ModelID { get throws { try id.modelID } }
}


extension Microsoft.MSALSession {
    var modelID: Account.ModelID { get throws { try id.modelID } }
}

// MARK: - Google -> Account.ModelID

extension Google.Account.ID {
    var modelID: Account.ModelID {
        .init(platform: .google, platformID: string)
    }
}

extension Google.Account {
    var modelID: Account.ModelID { id.modelID }
}

extension Google.GTMAuthSession {
    var modelID: Account.ModelID { get throws { try id.modelID } }
}


// MARK: - GOOGLE.MSALAccount, Microsoft.MSALSession -> Microsoft.Account.ID





/*
extension Microsoft.Account {
    var modelID: Account.ModelID { id.modelID }
}

*/

extension Microsoft.MailFolder {
    var modelID: MailFolder.ModelID {
        .init(platform: .microsoft, platformID: id.string)
    }
    
    /*func model(_ context: ModelContext) throws -> MailFolder? {
        return try context.fetchMailFolder(modelID: modelID)
    }*/
}

extension Microsoft.Message {
    var modelID: Message.ModelID {
        .init(platform: .microsoft, platformID: id.string)
    }
    
    /*func model(_ context: ModelContext) throws -> Message? {
        return try context.message(modelID: modelID)
    }*/
}

// MARK: - Model <-> MSGraph

extension Account {
    convenience init(microsoft: Microsoft.Account, orderIndex: Int) throws {
        self.init(
            modelID: microsoft.modelID,
            username: microsoft.username,
            orderIndex: orderIndex
        )
    }
    
    var graph: Microsoft.Account? {
        @available(macOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        @available(iOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        get {
            nil // should use graph(_:)
        }
        set {
            guard let graph = newValue else { return }
            self.modelID  = graph.modelID
            self.username = graph.username
        }
    }
    
    func update(microsoft: Microsoft.Account, deleteMark: Bool = false) {
        if self.modelID == microsoft.modelID && self.username == microsoft.username && self.deleteMark == deleteMark { return }
        self.deleteMark = deleteMark
        self.modelID  = microsoft.modelID
        self.username = microsoft.username
    }
}


extension MailFolder {
    convenience init(microsoft: Microsoft.MailFolder, in account: Account) {
        self.init(
            modelID: microsoft.modelID,
            name   : microsoft.displayName ?? "",
            in     : account
        )
        
        self._graph = try? microsoft.jsonString
    }
    
    var microsoft: Microsoft.MailFolder? {
        get {
            try? _graph?.decodeJSON(Microsoft.MailFolder.self)
        }
        set {
            guard let graph = newValue else { return }
            self.modelID  = graph.modelID
            self.name     = graph.displayName ?? ""
            
            self._graph   = try? graph.jsonString
        }
    }
    
    /*
     func update(graph: MSGraph.MailFolder, in account: Account) {
         self.modelID  = graph.modelID
         self.name     = graph.displayName ?? ""
         self.account  = account
         
         self._graph   = try? graph.jsonString
     }
     */
}

extension Message {

    var microsoft: Microsoft.Message? {
        get {
            try? _graph?.decodeJSON(Microsoft.Message.self)
        }
        set {
            guard let graph = newValue else { return }
            self.modelID      = graph.modelID
            self.subject      = graph.subject?.nilIfEmpty
            
            self.createdDate  = graph.createdDateTime?     .date
            self.modifiedDate = graph.lastModifiedDateTime?.date
            self.receivedDate = graph.receivedDateTime?    .date
            self.sentDate     = graph.sentDateTime?        .date
            
            self.sender       = graph.sender?.emailAddress
            self.from         = graph.from?.emailAddress
            self.to           = graph.toRecipients? .compactMap(\.emailAddress).nilIfEmpty
            self.replyTo      = graph.replyTo?      .compactMap(\.emailAddress).nilIfEmpty
            self.cc           = graph.ccRecipients? .compactMap(\.emailAddress).nilIfEmpty
            self.bcc          = graph.bccRecipients?.compactMap(\.emailAddress).nilIfEmpty
            
            self.bodyPreview  = graph.bodyPreview?.nilIfEmpty
            self.body         = graph.body
            self.uniqueBody   = graph.uniqueBody

            self._graph = try? graph.jsonString
        }
    }
    
    /*convenience init(graph: MSGraph.Message, in mailFolder: MailFolder) {
        self.init(modelID: graph.modelID, in: mailFolder)
        self.graph = graph
    }*/

    /*var graph: MSGraph.Message {
        get throws {
            guard let _graph else { throw SwiftDataError.noGraphInstance(model: self) }
            return try _graph.jsonDecode(MSGraph.Message.self)
        }
    }*/
}

// MARK: - MSGraph -> MSGraph: ID

extension Account {
    var microsoftID: Microsoft.Account.ID? {
        guard case .microsoft(let microsoftID) = self.modelID.enumValue else { return nil }
        return microsoftID
    }
}

extension MailFolder {
    var microsoftID: Microsoft.MailFolder.ID? {
        guard case .microsoft(let microsoftID) = self.modelID.enumValue else { return nil }
        return microsoftID
    }
}

extension Message {
    var microsoftID: Microsoft.Message.ID? {
        guard case .microsoft(let microsoftID) = self.modelID.enumValue else { return nil }
        return microsoftID
    }
}

// MARK: - Model <- MSGraph: ID




