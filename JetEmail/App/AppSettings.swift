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
    
    // Target Folder
    var targetFolderPaths: [[FolderName]] { FolderPaths.shared }
    var targetFolderTree: Tree<FolderName> { FolderPaths.sharedTree }
    var targetFolderTreeRootChildren: [TreeNode<FolderName>] { targetFolderTree.root.children }
    
    //
    var isOnColorScheme: Bool {
        get {
            access(keyPath: \.isOnColorScheme)
            return UserDefaults.standard.isOnColorScheme ?? true
        }
        set {
            withMutation(keyPath: \.isOnColorScheme) {
                UserDefaults.standard.isOnColorScheme = newValue
            }
        }
    }
    
    init() {
        appContextResult = .init(catching: AppContext.init)
        appContext?._settings = self
    }
}

extension UserDefaults {
    
    private enum Keys: String {
        case isOnColorScheme
    }
    
    var isOnColorScheme: Bool? {
        get {
            value(forKey: Keys.isOnColorScheme.rawValue) as? Bool
        }
        set {
           set(newValue, forKey: Keys.isOnColorScheme.rawValue)
        }
    }
}
