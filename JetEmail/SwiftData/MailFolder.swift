//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for KeyPathComparator

@Model
class MailFolder {
    
    @Attribute(.unique)
    var id: String
    
    @Transient
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _id)
        init(initialValue) {
            _$backingData.setValue(forKey: \.id, to: initialValue.string)
            _id = _SwiftDataNoType()
        }

        get { ModelID(id) }
        set { id = newValue.string }
    }
    
    var name: String
    
    /// MailFolder.account <<-> Account.mailFolders
    @Relationship(deleteRule: .nullify)
    var account: Account
    
    //@Relationship(deleteRule: .nullify)
    //var rootAccount: Account?
    
    /// MailFolder.parent <<-> MailFOlder.children
    @Relationship(deleteRule: .nullify)
    var parent: MailFolder?
    
    /// MailFolder.children <->> MailFolder.parent
    @Relationship(deleteRule: .nullify, originalName: "children", inverse: \MailFolder.parent)
    private var _children: [MailFolder] = [] // Should be Ordered Relationship
    
    @Transient
    var children: [MailFolder] { _children.sorted(using: KeyPathComparator(\.name)) }
    
    /// MailFolder.messages <->> Message.mailFolder
    @Relationship(deleteRule: .cascade, originalName: "messages", inverse: \Message.mailFolder)
    var _messages: [Message] = [] // Should be Ordered Relationship
    
    @Transient
    var messages: [Message] { _messages.sorted(using: KeyPathComparator(\.receivedDate, order: .reverse))}
    
    init(modelID: ModelID, name: String, in account: Account) {
        self.modelID  = modelID
        self.name     = name
        self.account  = account
    }
    
    var _graph: String?
    
    @MainActor  // for isBusy
    @Attribute(.ephemeral)
    var isBusy = false {
        willSet {
            print(isBusy)
        }
    }
    
    var deleteMark = false {
        didSet {
            if deleteMark {
                messages.forEach { $0.deleteMark = true }
            }
        }
    }
}
            
    /*var graph: MSGraph.MailFolder {
        get {
            // (try? _element.jsonDecode(MSGraph.MailFolder.self)) ?? .init()
            fatalError()
        }
        set {
            guard let graphJSONString: String = try? newValue.jsonString else { return }
            self._element = graphJSONString
            self.id   = newValue.id.rawValue
            self.name = newValue.displayName ?? ""
        }
    }*/


