//
//  Model+Graph.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Data
import SwiftData
import os

typealias AppItemModel<Item: DataModel> = CombineContext<AppModel, Item>

extension AppModel {
    func callAsFunction<Item: DataModel>(_ item: Item) -> AppItemModel<Item> {
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
    
    func callAsFunction(_ persistentID: Account.ID) throws -> AppItemModel<Account>? {
        guard let item = try ModelContainer.shared.mainContext[persistentID] else { return nil }
        return AppItemModel(context: self, item: item)
    }
    
    func callAsFunction(_ persistentID: MailFolder.ID) throws -> AppItemModel<MailFolder>? {
        guard let item = try ModelContainer.shared.mainContext[persistentID] else { return nil }
        return AppItemModel(context: self, item: item)
    }
    
    func callAsFunction(_ persistentID: Message.ID) throws -> AppItemModel<Message>? {
        guard let item = try ModelContainer.shared.mainContext[persistentID] else { return nil }
        return AppItemModel(context: self, item: item)
    }
}
