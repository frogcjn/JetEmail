//
//  PersistentID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftData

public struct PersistentID<Model : PersistentModel> : RawRepresentable {
    public let rawValue: PersistentIdentifier
    public init(rawValue: PersistentIdentifier) {
        self.rawValue = rawValue
    }
}

extension PersistentID : CodableValueType, Sendable {}

public extension PersistentModel {
    typealias PersistentID = JetEmailData.PersistentID<Self>
    var persistentID: PersistentID {
        .init(rawValue: persistentModelID)
    }
}
