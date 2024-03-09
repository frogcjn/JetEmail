//
//  Account.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

@MainActor
public extension Account {
    typealias AttributesStore = JetEmail_Data.AttributesStore<Account.ID, Account.Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy = false
        public init() {}
    }
}

@MainActor
public extension Account {
    var isBusy: Bool {
        get { id.isBusy }
        set { id.isBusy = newValue }
    }
}

@MainActor
public extension Account.ID {
    var isBusy: Bool {
        get { AttributesStore.shared[self].isBusy }
        set { AttributesStore.shared[self].isBusy = newValue }
    }
}
