//
//  ID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmail_Foundation

public enum UnifiedID<Model: DataModel> {
    case microsoft(Model.MicrosoftID)
    case    google(Model.GoogleID)
}

extension UnifiedID : PartialRawRepresentable {
    public var rawValue: String { "\(platform.rawValue)/\(platformID)" }
}

extension UnifiedID : Sendable where Model.MicrosoftID : Sendable, Model.GoogleID : Sendable {}
extension UnifiedID : Hashable, Equatable, Encodable/* where Model.MicrosoftID : StringIDProtocol, Model.GoogleID: StringIDProtocol*/ {}
