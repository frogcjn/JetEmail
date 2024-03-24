//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

public enum MailFolderLoadingMessageState {
    case none
    case start
    case checking(value: Int, total: Int)
    case loading(value: Int, total: Int)
    
    public var isLoading: Bool {
        switch self {
        case .start, .checking, .loading: true
        default: false
        }
    }
}

public struct MailFolderAttributes : AttributesProtocol {
    public var loadingMesageState = MailFolderLoadingMessageState.none
    public init() {}
}

public typealias MailFolderAttributesStore = JetEmailData.AttributesStore<MailFolderID, MailFolderAttributes>

public extension MailFolderAttributesStore {
    @MainActor
    static var shared = AttributesStore()
}

@MainActor
public extension MailFolderID {
    var loadingMessageState: MailFolderLoadingMessageState {
        get { MailFolderAttributesStore.shared[self].loadingMesageState }
        nonmutating set {
            MailFolderAttributesStore.shared[self].loadingMesageState = newValue
        }
    }
}
