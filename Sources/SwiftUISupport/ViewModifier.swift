//
//  ViewModifiers.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftUI
import JetEmailData


extension View {
    /*func appModel(_ appModel: AppModel) -> some View {
        modifier(AppModelResultModifier(appModel: appModel))
    }*/
    
    func itemModel<Item : UnifiedModel>(_ item: Item) -> some View {
        modifier(ItemModelModifier(item: item))
    }
}

// MARK: - Modifier: AppModel.Init

/*fileprivate struct AppModelResultModifier : ViewModifier {
    let appModel: AppModel
    func body(content: Content) -> some View {
        content
            .environment(appModel)
            .modelContainer(.shared)
    }
}*/

// MARK: - Modifier: AppModel.Item

fileprivate struct ItemModelModifier<Item: UnifiedModel> : ViewModifier {
    
    @Environment(AppModel.self)
    var appModel
    
    let item: Item
    
    func body(content: Content) -> some View {
        content
            .environment(appModel(item))
            .environment(item)
    }
}


@MainActor
extension Scene {
    func appModel(_ appModel: AppModel) -> some Scene {
        self
            .environment(appModel)
            .environment(SettingsModel.shared)
            .modelContainer(.shared)
    }
}
