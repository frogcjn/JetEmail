//
//  ViewModifiers.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftUI


extension View {
    func appModel(_ appModel: AppModel) -> some View {
        modifier(AppModelResultModifier(appModel: appModel))
    }
    
    func itemModel<Item : ModelItem>(_ item: Item) -> some View {
        modifier(ItemModelModifier(item: item))
    }
}

// MARK: - Modifier: AppModel.Init

fileprivate struct AppModelResultModifier : ViewModifier {
    let appModel: AppModel
    func body(content: Content) -> some View {
        content
            .environment(appModel)
            .modelContainer(appModel.modelContainer)
    }
}

// MARK: - Modifier: AppModel.Item

fileprivate struct ItemModelModifier<Item: ModelItem> : ViewModifier {
    
    @Environment(AppModel.self)
    var appModel
    
    let item: Item
    
    func body(content: Content) -> some View {
        content
            .environment(appModel(item))
            .environment(item)
    }
}


extension Scene {
    func appModel(_ appModel: AppModel) -> some Scene {
        self
            .environment(appModel)
            .environment(appModel.settings)
            .modelContainer(appModel.modelContainer)
    }
}
