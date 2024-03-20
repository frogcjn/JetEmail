//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailData
import JetEmailID
import SwiftData


extension Message.AttributesStore {
    static var shared = AttributesStore()
}

public extension Clients {
    static var shared = Clients()
}

public extension ModelContainer {
    @MainActor
    static var shared = {
        do {
            return try ModelContainer(for: Account.self, MailFolder.self, Message.self)
        } catch {
            print(error)
            fatalError()
        }
    }()
}


extension ModelStore {
    
    @ModelStoreActor
    static var _shared: ModelStore?
    
    @ModelStoreActor
    public static var shared: ModelStore { get async {
        if let _shared { return _shared }
        let modelStore = await ModelStore(modelContainer: .shared)
        _shared = modelStore
        return modelStore
    } }
}

@globalActor
public actor ModelStoreActor : Actor {
    public static let shared = ModelStoreActor()
}
