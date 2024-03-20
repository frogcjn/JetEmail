//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailData
import JetEmailData


public extension Clients {
    static var shared = Clients()
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
