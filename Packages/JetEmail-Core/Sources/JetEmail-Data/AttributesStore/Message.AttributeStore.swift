//
//  Message.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

@MainActor
public extension Message {
    typealias AttributesStore = JetEmail_Data.AttributesStore<Message.ID, Message.Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy        = false
        public var isClassifying = false
        public var movePlan: MailFolder?
        public init() {}
    }
}

@MainActor
public extension Message.ID {
    var isBusy: Bool {
        get { AttributesStore.shared[self].isBusy }
        set { AttributesStore.shared[self].isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { AttributesStore.shared[self].isClassifying }
        set { AttributesStore.shared[self].isClassifying = newValue }
    }
    
    var movePlan: MailFolder? {
        get { AttributesStore.shared[self].movePlan }
        set { AttributesStore.shared[self].movePlan = newValue }
    }
}

@MainActor
public extension Message {
    var isBusy: Bool {
        get { id.isBusy }
        set { id.isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { id.isClassifying }
        set { id.isClassifying = newValue }
    }
    
    var movePlan: MailFolder? {
        get { id.movePlan }
        set { id.movePlan = newValue }
    }
}
