//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for Date

// @dynamicMemberLookup
@Model
class Message : ModelItem {
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    private(set) var id: String
    private(set) var platform: String
    private(set) var platformID: String
    
    var      subject: String?
    
    // Originator Fields
    
    var         from: String?
    var       sender: String?
    var      replyTo: String? // 回复给
    
    // Destination Address Fields
    var           to: String? // * Important * to
    var           cc: String? // * Important * 抄送, carbon copy
    var          bcc: String? // 密件抄送，密送，blind carbon copy*/
    var  deliveredTo: String?

    var         date: Date?
    var  createdDate: Date?
    var modifiedDate: Date?
    var receivedDate: Date? // * Important *
    var     sentDate: Date?
    
    /* Orgnized */
    
    var  bodyPreview: String?
    var         body: Body?
    var          raw: Data?
    // var   uniqueBody: Body?

    
    /// Message.mailFolder <<-> MailFolder.messages
    @Relationship(deleteRule: .nullify)
    var mailFolder: MailFolder
    
    init(modelID: ModelID, in mailFolder: MailFolder) {
        self.modelID          = modelID
        self.mailFolder       = mailFolder
    }
    
    var deleteMark = false
    
    
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _platformID, _id)
        init(initialValue) {
            let (platform, platformID, string) = (initialValue.platform, initialValue.platformID, initialValue.string)
            _$backingData.setValue(forKey: \.id,         to: string)
            _$backingData.setValue(forKey: \.platform,   to: platform.rawValue)
            _$backingData.setValue(forKey: \.platformID, to: platformID)

            _id         = _SwiftDataNoType()
            _platform   = _SwiftDataNoType()
            _platformID = _SwiftDataNoType()
        }
        get { .init(platform: .init(rawValue: platform)!, platformID: platformID) }
        set {
            id         = newValue.string
            platform   = newValue.platform.rawValue
            platformID = newValue.platformID
        }
    }
    
    var _graph : String?
    var _google: String?
    
    struct Body: Codable {
        let text: String
        let html: String?
        
        init?(text: String? = nil, html: String? = nil) {
            switch (text, html) {
            case (let text?, let html?):
                self.text = text.removingHTMLTags
                self.html = html
            case (nil, let html?):
                self.text = html.removingHTMLTags
                self.html = html
            case (let text?, nil):
                self.text = text.removingHTMLTags
                self.html = nil
            case (nil, nil):
                return nil
            }
        }
    }
}

/*extension Message {
    
    var appModel: AppModel { .shared }
    
}*/

@MainActor // for @MainActor AttributesStore
extension Message {
    
    var isBusy: Bool {
        get { AttributesStore[modelID].isBusy }
        set { AttributesStore[modelID].isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { AttributesStore[modelID].isClassifying }
        set { AttributesStore[modelID].isClassifying = newValue }
    }
    
    var moveTo: MailFolder? {
        get { AttributesStore[modelID].moveTo }
        set { AttributesStore[modelID].moveTo = newValue }
    }
    
    /*subscript<Value>(dynamicMember keyPath: KeyPath<Attributes, Value>) -> Value {
        AttributesStore[modelID][keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Attributes, Value>) -> Value {
        _read { yield AttributesStore[modelID][keyPath: keyPath] }
        _modify { yield &AttributesStore[modelID][keyPath: keyPath] }
    }*/
    
}

extension Message {
    
    @MainActor // for @MainActor AttributesStore
    @Observable
    class AttributesStore {
        var rawValue = [Message.ModelID: Message.Attributes]()
        
        static subscript(modelID: Message.ModelID) -> Message.Attributes {
            get {
                if let properties = shared.rawValue[modelID] { return properties }
                let properties = Message.Attributes()
                shared.rawValue[modelID] = properties
                return properties
            }
            set { shared.rawValue[modelID] = newValue }
        }
    }
    
    struct Attributes {
        var isBusy = false
        var isClassifying = false
        var moveTo: MailFolder? = nil
        var isMoveToVisible = false
    }
}
/*
struct Recipient {
    let email: String
    let name: String?
}
*/

