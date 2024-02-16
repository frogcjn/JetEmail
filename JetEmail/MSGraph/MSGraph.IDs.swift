//
//  MSGraph.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

// MARK: - MSAL + StringID

extension MSGraph.Account {
    public struct ID : StringID {
        public let string: String
        public init(_ string: String) { self.string = string }
    }
}

extension MSGraph.MailFolder {
    public struct ID : StringID {
        public let string: String
        public init(_ string: String) { self.string = string }
    }
}

extension MSGraph.Message {
    public struct ID : StringID {
        public let string: String
        public init(_ string: String) { self.string = string }
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
