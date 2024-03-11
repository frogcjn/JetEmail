//
//  Model+Graph.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Data
import SwiftData
import os
import JetEmail_ID

typealias AppItemModel<Item: UnifiedModel> = CombineContext<AppModel, Item>

extension AppModel {
    func callAsFunction<Item: UnifiedModel>(_ item: Item) -> AppItemModel<Item> {
        AppItemModel(context: self, item: item)
    }
    
    /*func callAsFunction<Item: DataModel>(_ persistentID: Item.ID) -> AppItemModel<Item>? {
     guard let item = ModelContainer.shared.mainContext[persistentID] else { return nil }
     return AppItemModel(context: self, item: item)
     }*/
}

extension AppModel {
    /*func callAsFunction<Item: DataModel>(_ id: Item.ID) -> AppItemModel<Item>? {
        guard let item = try ModelContainer.shared.mainContext[id] else { return nil }
        return AppItemModel(context: self, item: item)
    }*/
    
    func callAsFunction(_ persistentID: AccountID) throws -> AppItemModel<Account>? {
        guard let item = try ModelContainer.shared.mainContext[persistentID] else { return nil }
        return AppItemModel(context: self, item: item)
    }
    
    func callAsFunction(_ persistentID: MailFolderID) throws -> AppItemModel<MailFolder>? {
        guard let item = try ModelContainer.shared.mainContext[persistentID] else { return nil }
        return AppItemModel(context: self, item: item)
    }
    
    func callAsFunction(_ persistentID: MessageID) throws -> AppItemModel<Message>? {
        guard let item = try ModelContainer.shared.mainContext[persistentID] else { return nil }
        return AppItemModel(context: self, item: item)
    }
}

extension AppModel {
    var mainContext: ModelContext {
        ModelContainer.shared.mainContext
    }
}

extension AccountID {
    @MainActor
    var mainContext: ModelContext {
        ModelContainer.shared.mainContext
    }
}

extension AppItemModel where Context == AppModel {
    var mainContext: ModelContext {
        context.mainContext
    }
}

