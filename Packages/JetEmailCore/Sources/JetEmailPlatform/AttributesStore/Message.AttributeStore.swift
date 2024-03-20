//
//  Message.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailID
import JetEmailData

@MainActor
public extension Message {
    typealias AttributesStore = JetEmailID.AttributesStore<String, Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy        = false
        public var isClassifying = false
        public var movePlan: MailFolder?
        public init() {}
    }
}

@MainActor
public extension Message.ResourceID {
    var isBusy: Bool {
        get { Message.AttributesStore.shared[uniqueID].isBusy }
        nonmutating set { Message.AttributesStore.shared[uniqueID].isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { Message.AttributesStore.shared[uniqueID].isClassifying }
        nonmutating set { Message.AttributesStore.shared[uniqueID].isClassifying = newValue }
    }
    
    var movePlan: MailFolder? {
        get { Message.AttributesStore.shared[uniqueID].movePlan }
        nonmutating set { Message.AttributesStore.shared[uniqueID].movePlan = newValue }
    }
}

@MainActor
public extension Message {
    var isBusy: Bool {
        get { resourceID.isBusy }
        set { resourceID.isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { resourceID.isClassifying }
        set { resourceID.isClassifying = newValue }
    }
    
    var movePlan: MailFolder? {
        get { resourceID.movePlan }
        set { resourceID.movePlan = newValue }
    }
}
