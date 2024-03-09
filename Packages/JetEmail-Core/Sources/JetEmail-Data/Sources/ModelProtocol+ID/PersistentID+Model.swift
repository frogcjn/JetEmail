//
//  PersistentID+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftData

public extension PersistentModel {
    typealias PersistentID = JetEmail_Data.PersistentID<Self>
    var persistentID: PersistentID {
        .init(rawValue: persistentModelID)
    }
}
/*
extension ModelContext {
    subscript<T: PersistentModel>(persistentID: PersistentID<T>) -> T? {
        model(for: persistentID.rawValue) as? T
    }
}

extension ModelActor {
    subscript<T: PersistentModel>(persistentID: PersistentID<T>) -> T? {
        self[persistentID.rawValue ,as: T.self]
    }
}*/
