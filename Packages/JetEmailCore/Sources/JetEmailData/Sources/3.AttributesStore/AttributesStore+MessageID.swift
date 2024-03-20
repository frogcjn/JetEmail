//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

extension MessageID {
    typealias AttributesStore = JetEmailData.AttributesStore<MessageID, Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy        = false
        public var isClassifying = false
        public var movePlanID: MailFolderID?
        public init() {}
    }
}

extension MessageID.AttributesStore {
    @MainActor
    static var shared = AttributesStore()
}

@MainActor
public extension MessageID {
    var isBusy: Bool {
        get { MessageID.AttributesStore.shared[self].isBusy }
        nonmutating set { MessageID.AttributesStore.shared[self].isBusy = newValue }
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
