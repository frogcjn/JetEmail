//
//  MailFolderViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI

@dynamicMemberLookup
@Observable
class MailFolderViewModel {
    
    typealias MailFolder = Microsoft.Graph.MailFolder
    // init
    var _windowViewModel: WindowViewModel
    var _mailFolder: MailFolder
    
    init(_ windowViewModel: WindowViewModel, mailFolder: MailFolder) {
        _windowViewModel = windowViewModel
        _mailFolder = mailFolder
    }
    
    var isLoadingMessages = false
    var errorMessage = ""
    var messages: [Microsoft.Graph.Message] = []
}

extension MailFolderViewModel {
    
    func loadMessages() async {
        guard !self.isLoadingMessages else { return }
        self.isLoadingMessages = true
        defer { self.isLoadingMessages = false }
        
        do {
            messages = try await self.mailFoldersRequest.getMessages(id: self.id)
        } catch {
            errorMessage = String(describing: error)
        }
    }
}

// @dynamicMemberLookup
extension MailFolderViewModel {
    subscript<Value>(dynamicMember keyPath: KeyPath<WindowViewModel, Value>) -> Value {
        _windowViewModel[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<WindowViewModel, Value>) -> Value {
        get {
            _windowViewModel[keyPath: keyPath]
        }
        set {
            _windowViewModel[keyPath: keyPath] = newValue
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<MailFolder, Value>) -> Value {
        _mailFolder[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<MailFolder, Value>) -> Value {
        get {
            _mailFolder[keyPath: keyPath]
        }
        set {
            _mailFolder[keyPath: keyPath] = newValue
        }
    }
}
