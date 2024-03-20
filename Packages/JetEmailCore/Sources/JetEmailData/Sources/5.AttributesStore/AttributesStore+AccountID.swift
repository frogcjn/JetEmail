//
//  Account.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

extension AccountID {
    typealias AttributesStore = JetEmailData.AttributesStore<AccountID, Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy           = false
        public var loadedMailFolder = false
        public init() {}
    }
}

extension AccountID.AttributesStore {
    @MainActor
    static var shared = AttributesStore()
}

@MainActor
public extension AccountID {
    var isBusy: Bool {
        get { AccountID.AttributesStore.shared[self].isBusy }
        nonmutating set { AccountID.AttributesStore.shared[self].isBusy = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { AccountID.AttributesStore.shared[self].loadedMailFolder }
        nonmutating set {AccountID.AttributesStore.shared[self].loadedMailFolder = newValue }
    }
}
