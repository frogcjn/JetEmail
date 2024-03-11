//
//  MailFolder.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

@MainActor
public extension MailFolder {
    typealias AttributesStore = JetEmail_Data.AttributesStore<MailFolder, String, Attributes>
    struct Attributes : AttributesProtocol {
        public var loadingMesageState = LoadingMessageState.none
        public init() {}
    }
    
    enum LoadingMessageState {
        case none
        case start
        case loading(value: Int, total: Int)
        
        public var isLoading: Bool {
            switch self {
            case .start: true
            case .loading: true
            default: false
            }
        }
    }
}

@MainActor
public extension MailFolder.ResourceID {
    var loadingMessageState: MailFolder.LoadingMessageState {
        get { MailFolder.AttributesStore.shared[uniqueID].loadingMesageState }
        nonmutating set {
            MailFolder.AttributesStore.shared[uniqueID].loadingMesageState = newValue
        }
    }
}

