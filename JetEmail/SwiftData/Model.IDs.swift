//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// MARK: - Model + StringID

extension Account : Hashable, Equatable, Identifiable {
    typealias ID = String
    // var id: String { id }
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        lhs.persistentModelID == rhs.persistentModelID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(persistentModelID)
    }
}

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
    public struct ModelID : StringID {
        public let string: String
        public init(_ string: String) { self.string = string }
    }
}

extension MailFolder {
    public struct ModelID : StringID {
        public let string: String
        public init(_ string: String) { self.string = string }
    }
}

extension Message {
    public struct ModelID : StringID {
        public let string: String
        public init(_ string: String) { self.string = string }
    }
}
