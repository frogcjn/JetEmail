//
//  WindowViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import SwiftData
import MSAL

@dynamicMemberLookup
@Observable
class WindowViewModel {
        
    // App View Model
    private var _appViewModel: AppViewModel
        
    init(_ appViewModel: AppViewModel) {
        self._appViewModel = appViewModel
    }
    
    // properties
    var splitViewVisibility: NavigationSplitViewVisibility = .all
    var selectedMailFolder: MailFolder? = nil {
        willSet {
            print(newValue)
            print("Why?")
        }
    }
    var selectedMessage: Message? = nil

    // account view models
    private var _accountViewModels: [Account: AccountViewModel] = [:]
    subscript(account account: Account) -> AccountViewModel {
        get {
            if let accountContext = _accountViewModels[account] {
                return accountContext
            } else {
                let navigation = AccountViewModel(self, account: account)
                _accountViewModels[account] = navigation
                return navigation
            }
        }
    }
    
    // conversation view models
    private var _mailFolderViewModels: [MailFolder: MailFolderViewModel] = [:]
    subscript(mailFolder mailFolder: MailFolder) -> MailFolderViewModel {
        get {
            if let navigation = _mailFolderViewModels[mailFolder] {
                return navigation
            } else {
                let navigation = MailFolderViewModel(self[account: mailFolder.account], mailFolder: mailFolder)
                _mailFolderViewModels[mailFolder] = navigation
                return navigation
            }
        }
    }
    
    // message view models
    private var _messageViewModels: [Message: MessageViewModel] = [:]
    subscript(message message: Message) -> MessageViewModel {
        get {
            if let navigation = _messageViewModels[message] {
                return navigation
            } else {
                let navigation = MessageViewModel(self, message: message)
                _messageViewModels[message] = navigation
                return navigation
            }
        }
    }
}

extension TreeNode : Identifiable where Element : Identifiable {
    
}

extension TreeNode: Equatable where Element: Equatable {
    static func == (lhs: TreeNode<Element>, rhs: TreeNode<Element>) -> Bool {
        lhs.element == rhs.element
    }
}

extension TreeNode : Hashable where Element : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(element)
    }
}


// @dynamicMemberLookup
extension WindowViewModel {
    subscript<Value>(dynamicMember keyPath: KeyPath<AppViewModel, Value>) -> Value {
        _appViewModel[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<AppViewModel, Value>) -> Value {
        get {
            _appViewModel[keyPath: keyPath]
        }
        set {
            _appViewModel[keyPath: keyPath] = newValue
        }
    }
}
