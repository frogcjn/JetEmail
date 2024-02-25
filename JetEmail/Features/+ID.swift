//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import Foundation
import SwiftData

// MARK: - Model + StringID

extension String {
    var googleID: Google.ID {
        .init(string: self)
    }
}

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
    /*struct ModelID: ModelIDProtocol {
        let platform: Platform
        let platformID: String
    }*/
    
    enum ModelID : ModelIDProtocol {
        case microsoft(Microsoft.ID)
        case google(Google.ID)
    }
}

extension MailFolder {
    enum ModelID : ModelIDProtocol {
        case microsoft(Microsoft.MailFolder.ID)
        case google(Google.MailFolder.ID)
    }
}

extension Message {
    enum ModelID: ModelIDProtocol {
        case microsoft(Microsoft.Message.ID)
        case google(Google.Message.ID)
        //let platform: Platform
        //let platformID: String
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

extension PersistentID : Equatable {
    static func ==(lhs: PersistentID, rhs: PersistentID) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
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
    
    var platform: Platform {
        switch self {
        case .microsoft: .microsoft
        case .google   : .google
        }
    }
    
    var platformID: String {
        switch self {
        case .microsoft(let platformID): platformID.string
        case .google   (let platformID): platformID.string
        }
    }
    
    init(platform: Platform, platformID: String) {
        self = switch platform {
        case .microsoft: .microsoft(.init(string:platformID))
        case .google   : .google   (.init(string:platformID))
        }
    }
}

extension MailFolder.ModelID {

    /*enum Enum : Codable {
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
    }*/
    
    var platform: Platform {
        switch self {
        case .microsoft: .microsoft
        case .google   : .google
        }
    }
    
    var platformID: String {
        switch self {
        case .microsoft(let platformID): platformID.string
        case .google   (let platformID): platformID.string
        }
    }
    
    init(platform: Platform, platformID: String) {
        self = switch platform {
        case .microsoft: .microsoft(.init(string:platformID))
        case .google   : .google   (.init(string:platformID))
        }
    }
}


extension Message.ModelID {
    
    var platform: Platform {
        switch self {
        case .microsoft: .microsoft
        case .google   : .google
        }
    }
    
    var platformID: String {
        switch self {
        case .microsoft(let platformID): platformID.string
        case .google   (let platformID): platformID.string
        }
    }
    
    init(platform: Platform, platformID: String) {
        self = switch platform {
        case .microsoft: .microsoft(.init(string:platformID))
        case .google   : .google   (.init(string:platformID))
        }
    }
}

/*
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

*/







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

// MARK: - Microsoft.ID

extension Microsoft {
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
// MARK: - Google.ID

extension Google {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}

extension Google.MailFolder {
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

// MARK: Microsoft -> Microsoft.ID

extension Microsoft.MSALAccount {
    var id: Microsoft.ID {
        get throws {
            guard let stringID = identifier else { throw Microsoft.AuthError.accountNoIDOrUsername }
            return .init(string: stringID)
        }
    }
    
    var idAndUsername: (id: Microsoft.ID, username: String) {
        get throws {
            guard let stringID = identifier, let username else { throw Microsoft.AuthError.accountNoIDOrUsername }
            return (.init(string: stringID), username)
        }
    }
}

extension Microsoft.MSALSession {
    var id: Microsoft.ID { get throws { try account.id } }
}


// MARK: Google -> Google.ID

extension Google.GTMSession {
    var id: Google.ID {
        get throws {
            guard let stringID = userID else { throw Google.AuthError.accountNoIDOrUsername }
            return .init(string: stringID)
        }
    }
    
    var idAndUsername: (id: Google.ID, username: String) {
        get throws {
            guard let stringID = userID, let username = userEmail else { throw Google.AuthError.accountNoIDOrUsername }
            return (.init(string: stringID), username)
        }
    }
}


// MARK: - Microsoft -> Account.ModelID

extension Microsoft.ID {
    var modelID: Account.ModelID {
        .microsoft(self)
    }
}
/*
extension Microsoft.Account {
    var modelID: Account.ModelID { id.modelID }
}*/

extension Microsoft.MSALAccount {
    var modelID: Account.ModelID { get throws { try id.modelID } }
}


extension Microsoft.MSALSession {
    var modelID: Account.ModelID { get throws { try id.modelID } }
}

// MARK: - Google -> Account.ModelID

extension Google.ID {
    var modelID: Account.ModelID {
        .google(self)
    }
}

extension Google.Session {
    var modelID: Account.ModelID { accountID.modelID }
}

extension Google.GTMSession {
    var modelID: Account.ModelID { get throws { try id.modelID } }
}


// MARK: - GOOGLE.MSALAccount, Microsoft.MSALSession -> Microsoft.ID


extension Microsoft.Session {
    var modelID: Account.ModelID { id.modelID }
}


extension Microsoft.MailFolder {
    var modelID: MailFolder.ModelID {
        .init(platform: .microsoft, platformID: id.string)
    }
    
    /*func model(_ context: ModelContext) throws -> MailFolder? {
        return try context.fetchMailFolder(modelID: modelID)
    }*/
}

extension Google.MailFolder {
    var modelID: MailFolder.ModelID {
        .init(platform: .google, platformID: id.string)
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

extension Google.Message.Full {
    var modelID: Message.ModelID {
        .init(platform: .google, platformID: id.string)
    }
}

// MARK: - Model <-> MSGraph
/*
extension Account {
    convenience init(microsoft: Microsoft.Account) throws {
        self.init(
            modelID: microsoft.modelID,
            username: microsoft.username
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
*/

extension MailFolder {
    convenience init(microsoft: Microsoft.MailFolder, in account: Account) {
        self.init(
            modelID: microsoft.modelID,
            name   : microsoft.displayName ?? "",
            in     : account
        )
        
        self._graph = try? microsoft.jsonString
    }
    
    convenience init(google: Google.MailFolder, in account: Account) {
        self.init(
            modelID: google.modelID,
            name   : google.name ?? "",
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
            self._google = nil
        }
    }
    
    var google: Google.MailFolder? {
        get {
            try? _google?.decodeJSON(Google.MailFolder.self)
        }
        set {
            guard let google = newValue else { return }
            self.modelID = google.modelID
            self.name = google.name ?? ""
            self._google = try? google.jsonString
            self._graph = nil
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



// MARK: - MSGraph -> MSGraph: ID

extension Account {
    var microsoftID: Microsoft.ID? {
        guard case .microsoft(let microsoftID) = self.modelID else { return nil }
        return microsoftID
    }
}

extension MailFolder {
    var microsoftID: Microsoft.MailFolder.ID? {
        guard case .microsoft(let microsoftID) = modelID else { return nil }
        return microsoftID
    }
    
    var googleID: Google.MailFolder.ID? {
        guard case .google(let googleID) = modelID else { return nil }
        return googleID
    }
}

extension Message {
    var microsoftID: Microsoft.Message.ID? {
        guard case .microsoft(let microsoftID) = self.modelID else { return nil }
        return microsoftID
    }
}

// MARK: - Model <- MSGraph: ID




extension Session {
    var modelID: Account.ModelID {
        switch self {
        case .microsoft(let microsoftSession): microsoftSession.modelID
        case .google(let googleSession): googleSession.modelID
        }
    }
}


