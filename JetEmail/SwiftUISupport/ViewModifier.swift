//
//  ViewModifiers.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftUI


extension View {
    func appContext(init appContextInit: AppContextInit) -> some View {
        modifier(AppContextInitModifier(appContextInit: appContextInit))
    }
    
    func appContext<Item : Observable & AnyObject>(item: Item) -> some View {
        modifier(AppContextItemModifier(item: item))
    }
}

// MARK: - Modifier: AppContext.Init

fileprivate struct AppContextInitModifier : ViewModifier {
    let appContextInit: AppContextInit
    func body(content: Content) -> some View {
        ResultView(appContextInit.result) { appContext in
            content
                .environment(appContext)
                .modelContainer(appContext.modelContainer)
        }
    }
}

// MARK: - Modifier: AppContext.Item

fileprivate struct AppContextItemModifier<Item: Observable & AnyObject> : ViewModifier {
    
    @Environment(AppContext.self)
    var context
    
    let item: Item
    func body(content: Content) -> some View {
        content
            .environment(item)
            .environment(AppContext.Item(context: context, item: item))
    }
}

