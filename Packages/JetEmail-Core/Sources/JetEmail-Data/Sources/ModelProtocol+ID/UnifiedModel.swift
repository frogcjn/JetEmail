//
//  ModelItem.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftData
import JetEmail_Foundation

public protocol UnifiedModel<MicrosoftID, GoogleID> : PersistentModel {
    associatedtype MicrosoftID : CodableValueType, PartialRawRepresentable<String>
    associatedtype GoogleID : CodableValueType, PartialRawRepresentable<String>
    var rawID: String { get }
}

// MicrosoftID : CodableValueType & PartialRawRepresentable<String>, GoogleID : CodableValueType & PartialRawRepresentable<String>
