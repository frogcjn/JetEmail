//
//  Model+Graph.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import SwiftData
import os

typealias AppItemModel<Item: ModelItem> = CombineContext<AppModel, Item>

protocol ModelItem :PersistentModel, Observable, AnyObject {
    associatedtype ModelID
    var modelID: ModelID { get }
    // var isBusy: Bool { get set }
}

extension AppModel {
    func callAsFunction<Item: ModelItem>(_ item: Item) -> AppItemModel<Item> {
        AppItemModel(context: self, item: item)
    }
    
    func callAsFunction<Item: ModelItem>(_ persistentID: Item.PersistentID) -> AppItemModel<Item>? {
        guard let item = ModelContainer.shared.mainContext[persistentID] else { return nil }
        return AppItemModel(context: self, item: item)
    }
}
