//
//  MailFolder.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

@MainActor
public extension MailFolder {
    typealias AttributesStore = JetEmail_Data.AttributesStore<MailFolder.ID, MailFolder.Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy = false
        public init() {}
    }
}

@MainActor
public extension MailFolder.ID {
    var isBusy: Bool {
        get { AttributesStore.shared[self].isBusy }
        set { AttributesStore.shared[self].isBusy = newValue }
    }
}

@MainActor
public extension MailFolder {
    var isBusy: Bool {
        get { id.isBusy }
        set { id.isBusy = newValue }
    }
}
