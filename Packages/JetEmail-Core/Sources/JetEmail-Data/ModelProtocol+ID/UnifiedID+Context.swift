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
    
    subscript(id: UnifiedID<Account>) -> Account? { get throws {
        let uniqueID = id.rawValue
        return try fetch(.init(predicate: #Predicate<Account> { $0.rawID == uniqueID })).first
    } }
    
    subscript(id: UnifiedID<MailFolder>) -> MailFolder? { get throws {
        let uniqueID = id.rawValue
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.rawID == uniqueID })).first
    } }
    
    subscript(id: UnifiedID<Message>) -> Message? { get throws {
        let uniqueID = id.rawValue
        return try fetch(.init(predicate: #Predicate<Message> { $0.rawID == uniqueID })).first
    } }
}

public extension ModelActor {
    /*subscript<Model: DataModel>(id: UnifiedID<Model>) -> Model? { get throws {// TODO: WWDC2024
        try? modelContext[id]
    } }*/
    
    subscript(id: UnifiedID<Account>) -> Account? { get throws {
        try modelContext[id]
    } }
    
    subscript(id: UnifiedID<MailFolder>) -> MailFolder? { get throws {
        try modelContext[id]

    } }
    
    subscript(id: UnifiedID<Message>) -> Message? { get throws {
        try modelContext[id]
    } }
}

