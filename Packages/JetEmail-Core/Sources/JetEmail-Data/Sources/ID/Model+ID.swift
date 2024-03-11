//
//  File.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmail_Foundation
import SwiftData

public protocol UnifiedModel : PersistentModel  {
    associatedtype ResourceID : ResourceIDProtocol & UniqueID
    var resourceID : ResourceID { get }
}

public protocol UniqueID {
    var uniqueID: String { get }
}

extension String : UniqueID {
    public var uniqueID: String { self }
}

extension Account: UnifiedModel {
    public typealias ResourceID = AccountID
}

extension MailFolder: UnifiedModel {
    public typealias ResourceID = MailFolderID
}
extension Message: UnifiedModel {
    public typealias ResourceID = MessageID
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
