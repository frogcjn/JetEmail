//
//  UnifiedID+Context.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import Foundation // for #Predicate
import SwiftData // for ModelContext, ModelActor
import JetEmail_Foundation

public extension ModelContext {
    /*subscript<Model: DataModel>(id: UnifiedID<Model>) -> Model? { get throws { // TODO: WWDC2024
        let uniqueID = id.rawValue
        return try? fetch(.init(predicate: #Predicate<Model> { $0.uniqueID == uniqueID })).first // Error,  keypath could not figure right, since it is from protocol key path
    } }*/
    
    subscript(id: AccountID) -> Account? { get throws {
        let uniqueID = id.uniqueID
        return try fetch(.init(predicate: #Predicate<Account> { $0.uniqueID == uniqueID })).first
    } }
    
    subscript(id: MailFolderID) -> MailFolder? { get throws {
        let uniqueID = id.uniqueID
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.uniqueID == uniqueID })).first
    } }
    
    subscript(id: MessageID) -> Message? { get throws {
        let uniqueID = id.uniqueID
        return try fetch(.init(predicate: #Predicate<Message> { $0.uniqueID == uniqueID })).first
    } }
}

public extension ModelActor {
    /*subscript<Model: DataModel>(id: UnifiedID<Model>) -> Model? { get throws {// TODO: WWDC2024
        try? modelContext[id]
    } }*/
    
    subscript(id: AccountID) -> Account? { get throws {
        try modelContext[id]
    } }
    
    subscript(id: MailFolderID) -> MailFolder? { get throws {
        try modelContext[id]

    } }
    
    subscript(id: MessageID) -> Message? { get throws {
        try modelContext[id]
    } }
}

