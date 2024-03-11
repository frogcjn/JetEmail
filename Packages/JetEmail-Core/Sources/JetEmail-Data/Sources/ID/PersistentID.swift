//
//  PersistentID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftData
import JetEmail_ID

public struct PersistentID<Model : PersistentModel> : RawRepresentable {
    public let rawValue: PersistentIdentifier
    public init(rawValue: PersistentIdentifier) {
        self.rawValue = rawValue
    }
}

extension PersistentID : CodableValueType {}

public extension PersistentModel {
    typealias PersistentID = JetEmail_Data.PersistentID<Self>
    var persistentID: PersistentID {
        .init(rawValue: persistentModelID)
    }
}
