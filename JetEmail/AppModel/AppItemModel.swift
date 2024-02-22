//
//  Model+Graph.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import SwiftData
import os

typealias AppItemModel<Item: ModelItem> = CombineContext<AppModel, Item>

protocol ModelItem : Observable, AnyObject {
    associatedtype ModelID
    var modelID: ModelID { get }
    var isBusy: Bool { get set }
}

extension AppModel {
    func callAsFunction<Item: ModelItem>(_ item: Item) -> AppItemModel<Item> {
        AppItemModel(context: self, item: item)
    }
}
