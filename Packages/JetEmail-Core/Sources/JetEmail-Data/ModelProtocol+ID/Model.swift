//
//  ModelItem.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftData
import JetEmail_Foundation

public protocol DataModel<GoogleID, MicrosoftID> : PersistentModel where ID == UnifiedID<Self> {
    associatedtype GoogleID : StringIDProtocol
    associatedtype MicrosoftID : StringIDProtocol
    var rawID: String { get }
}
/*
extension DataModel {
    var uniqueID : String { id.rawValue }
}
*/
