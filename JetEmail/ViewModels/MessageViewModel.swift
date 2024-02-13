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
class MessageViewModel {
    // init
    var _windowViewModel: WindowViewModel
    var _message: Message
    
    var isClassifying = false
    var classifyResultText: String?
    
    init(_ windowViewModel: WindowViewModel, message: Message) {
        _windowViewModel = windowViewModel
        _message = message
    }
}

extension MessageViewModel {
    
    /*func classify() async {
        guard !self.isClassifying else { return }
        self.isClassifying = true
        defer { self.isClassifying = false }
        
        guard let tree = self.tree else { return }
        let message = _message
        do {
            
            let root = tree.root
            let accountContext = self._accountContext
            
            let archiveMailFolder = try await accountContext.mailFoldersRequest.getMailFolder(wellKnownFolderName: .archive)
            let junkMailFolder = try await accountContext.mailFoldersRequest.getMailFolder(wellKnownFolderName: .junkEmail)
            guard let archiveNode = root.children.first(where: { $0.id == archiveMailFolder.id }), let junkNode = root.children.first(where: { $0.id == junkMailFolder.id }) else {
                throw ClassifyError.noArchiveFolder
            }
            
            classifyResultText = try await Agent.classify(archiveNode: archiveNode, junkNode: junkNode, message: message) ?? "nil"
        } catch {
            classifyResultText = String(describing: error)
        }
    }*/
    
    
}

struct ClassifyResult : Codable {
    let existedFolder: String?
    
    private enum CodingKeys: String, CodingKey {
        case existedFolder = "existed_folder"
    }
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
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Message, Value>) -> Value {
        _message[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Message, Value>) -> Value {
        get {
            _message[keyPath: keyPath]
        }
        set {
            _message[keyPath: keyPath] = newValue
        }
    }
}
