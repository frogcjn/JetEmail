//
//  UnifiedID+Context.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import Foundation
import SwiftData

public extension ModelContext {
    /*subscript<Model: DataModel>(id: UnifiedID<Model>) -> Model? { get throws { // TODO: WWDC2024
        let uniqueID = id.rawValue
        return try? fetch(.init(predicate: #Predicate<Model> { $0.uniqueID == uniqueID })).first // Error,  keypath could not figure right, since it is from protocol key path
    } }*/
    
    subscript(id: Account.ID) -> Account? { get throws {
        let rawID = id.rawValue
        return try fetch(.init(predicate: #Predicate<Account> { $0.rawID == rawID })).first
    } }
    
    subscript(id: MailFolder.ID) -> MailFolder? { get throws {
        let rawID = id.rawValue
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.rawID == rawID })).first
    } }
    
    subscript(id: Message.ID) -> Message? { get throws {
        let rawID = id.rawValue
        return try fetch(.init(predicate: #Predicate<Message> { $0.rawID == rawID })).first
    } }
}

public extension ModelActor {
    /*subscript<Model: DataModel>(id: UnifiedID<Model>) -> Model? { get throws {// TODO: WWDC2024
        try? modelContext[id]
    } }*/
    
    subscript(id: Account.ID) -> Account? { get throws {
        try modelContext[id]
    } }
    
    subscript(id: MailFolder.ID) -> MailFolder? { get throws {
        try modelContext[id]

    } }
    
    subscript(id: Message.ID) -> Message? { get throws {
        try modelContext[id]
    } }
}

