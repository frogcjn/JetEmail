//
//  File.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmail_Foundation
import SwiftData

public protocol UnifiedModel : PersistentModel where ID : ResourceIDProtocol & UniqueID {
}

public protocol UniqueID {
    var uniqueID: String { get }
}

extension Account: UnifiedModel {
    public typealias ID = AccountID
}
extension MailFolder: UnifiedModel {
    public typealias ID = MailFolderID
}
extension Message: UnifiedModel {
    public typealias ID = MessageID
}

extension AccountID : UniqueID {
    public var uniqueID: String { "\(platform)/\(innerID)" }
}

extension MailFolderID : UniqueID {
    public var uniqueID: String { "\(platform)/\(accountID.innerID)/\(innerID)" }
}

extension MessageID : UniqueID {
    public var uniqueID: String { "\(platform)/\(accountID.innerID)/\(innerID)" }
}
