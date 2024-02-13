//
//  MailFolderViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import OpenAI

@dynamicMemberLookup
@Observable
class MailFolderViewModel {
    
    // init
    var _accountViewModel: AccountViewModel
    var _mailFolder: MailFolder

    init(_ accountViewModel: AccountViewModel, mailFolder: MailFolder) {
        _accountViewModel = accountViewModel
        _mailFolder = mailFolder
    }
    
    var isLoadingMessages = false
}

extension MailFolderViewModel {
    
    func loadMessages() async throws -> [Message] {
        guard !self.isLoadingMessages else { return [] }
        self.isLoadingMessages = true
        defer { self.isLoadingMessages = false }
        
        let msalMessages = try await self.mailFoldersRequest.getMessages(id: _mailFolder.id) // load from MSAL
        let messages = try await BackgroundModelActor(modelContainer: self.container).messages(elements: msalMessages, in: _mailFolder) // MSAL to SwiftData
        return messages
    }
}

// @dynamicMemberLookup
extension MailFolderViewModel {
    subscript<Value>(dynamicMember keyPath: KeyPath<AccountViewModel, Value>) -> Value {
        _accountViewModel[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<AccountViewModel, Value>) -> Value {
        get {
            _accountViewModel[keyPath: keyPath]
        }
        set {
            _accountViewModel[keyPath: keyPath] = newValue
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
