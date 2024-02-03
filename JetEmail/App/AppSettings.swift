//
//  AppSettings.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI
import MSAL

@Observable
class AppSettings {
    
    static var shared = AppSettings()
    
    // App Context
    let appContextResult: Result<AppContext, Error>
    var appContext: AppContext? { try? appContextResult.get() }
    var userContext: UserContext? { appContext?.user }
    
    // Folder List
    // Folder List
    var targetFolderPaths: [[FolderName]] { FolderPaths.shared }
    var targetFolderTree: Tree<FolderName> { FolderPaths.sharedTree }
    var targetFolderTreeRootChildren: [TreeNode<FolderName>] { targetFolderTree.root.children }
    
    init() {
        appContextResult = .init(catching: AppContext.init)
        appContext?._settings = self
    }
}
