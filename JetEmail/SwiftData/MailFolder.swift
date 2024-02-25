//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for KeyPathComparator

@Model
class MailFolder : ModelItem {
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    private(set) var id: String
    private(set) var platform: String
    private(set) var platformID: String
    
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _platformID, _id)
        init(initialValue) {
            let (platform, platformID, string) = (initialValue.platform, initialValue.platformID, initialValue.string)
            _$backingData.setValue(forKey: \.platform,   to: platform.rawValue)
            _$backingData.setValue(forKey: \.platformID, to: platformID)
            _$backingData.setValue(forKey: \.id,         to: string)

            _platform   = _SwiftDataNoType()
            _platformID = _SwiftDataNoType()
            _id         = _SwiftDataNoType()
        }
        get { .init(platform: .init(rawValue: platform)!, platformID: platformID) }
        set {
            platform   = newValue.platform.rawValue
            platformID = newValue.platformID
            id = newValue.string
        }
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
    var messages: [Message] { _messages.sorted(using: KeyPathComparator(\.date, order: .reverse))}
    
    init(modelID: ModelID, name: String, in account: Account) {
        self.modelID  = modelID
        self.name     = name
        self.account  = account
    }
    
    var _graph: String?
    var _google: String?

    var deleteMark = false {
        didSet {
            if deleteMark {
                messages.forEach { $0.deleteMark = true }
            }
        }
    }
    
}

extension MailFolder {
    
    var isBusy: Bool {
        get { AttributesStore[modelID].isBusy }
        set { AttributesStore[modelID].isBusy = newValue }
    }
    
    var appModel: AppModel { .shared }
}

extension MailFolder {
    @Observable
    class AttributesStore {
        var rawValue = [MailFolder.ModelID: MailFolder.Attributes]()
        
        static subscript(modelID: MailFolder.ModelID) -> MailFolder.Attributes {
            get {
                if let properties = shared.rawValue[modelID] { return properties }
                let properties = MailFolder.Attributes()
                shared.rawValue[modelID] = properties
                return properties
            }
            set { shared.rawValue[modelID] = newValue }
        }
    }
    
    struct Attributes {
        var isBusy = false
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


