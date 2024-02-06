//
//  MailFolderViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI

@dynamicMemberLookup
@Observable
class MessageViewModel {
    // init
    var _windowViewModel: WindowViewModel
    var _message: Microsoft.Graph.Message
    
    init(_ windowViewModel: WindowViewModel, message: Microsoft.Graph.Message) {
        _windowViewModel = windowViewModel
        _message = message
    }
}

extension MailFolderViewModel {
}

// @dynamicMemberLookup
extension MessageViewModel {
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
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Microsoft.Graph.Message, Value>) -> Value {
        _message[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Microsoft.Graph.Message, Value>) -> Value {
        get {
            _message[keyPath: keyPath]
        }
        set {
            _message[keyPath: keyPath] = newValue
        }
    }
}
