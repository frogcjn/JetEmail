//
//  Account.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

// MARK: AttributesStore + Account


@MainActor
extension AccountID.AttributesStore {
    static var shared = AttributesStore()
}

@MainActor
public extension AccountID {
    typealias AttributesStore = JetEmailData.AttributesStore<AccountID, Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy           = false
        public var loadedMailFolder = false
        public init() {}
    }
    var isBusy: Bool {
        get { AccountID.AttributesStore.shared[self].isBusy }
        nonmutating set { AccountID.AttributesStore.shared[self].isBusy = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { AccountID.AttributesStore.shared[self].loadedMailFolder }
        nonmutating set {AccountID.AttributesStore.shared[self].loadedMailFolder = newValue }
    }
}

@MainActor
public extension Account {
    var isBusy: Bool {
        get { resourceID.isBusy }
        set { resourceID.isBusy = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { resourceID.loadedMailFolder }
        set { resourceID.loadedMailFolder = newValue }
    }
}

// MARK: AttributesStore + Message

@MainActor
extension MessageID.AttributesStore {
    static var shared = AttributesStore()
}

@MainActor
public extension MessageID {
    typealias AttributesStore = JetEmailData.AttributesStore<MessageID, Attributes>
    struct Attributes : AttributesProtocol {
        public var isMoving      = false
        public var isLoadingBody = false
        public var isClassifying = false
        public var movePlanID: MailFolderID?
        public init() {}
    }
    
    var isMoving: Bool {
        get { MessageID.AttributesStore.shared[self].isMoving }
        nonmutating set { MessageID.AttributesStore.shared[self].isMoving = newValue }
    }
    
    var isLoadingBody: Bool {
        get { MessageID.AttributesStore.shared[self].isLoadingBody }
        nonmutating set { MessageID.AttributesStore.shared[self].isLoadingBody = newValue }
    }
    
    var isClassifying: Bool {
        get { MessageID.AttributesStore.shared[self].isClassifying }
        nonmutating set { MessageID.AttributesStore.shared[self].isClassifying = newValue }
    }
    
    var movePlanID: MailFolderID? {
        get { MessageID.AttributesStore.shared[self].movePlanID }
        nonmutating set { MessageID.AttributesStore.shared[self].movePlanID = newValue }
    }
}

@MainActor
public extension Message {
    var isMoving: Bool {
        get { resourceID.isMoving }
        set { resourceID.isMoving = newValue }
    }
    
    var isLoadingBody: Bool {
        get { resourceID.isLoadingBody }
        set { resourceID.isLoadingBody = newValue }
    }
    
    var isClassifying: Bool {
        get { resourceID.isClassifying }
        set { resourceID.isClassifying = newValue }
    }
    
    var movePlanID: MailFolderID? {
        get { resourceID.movePlanID }
        set { resourceID.movePlanID = newValue }
    }
}
