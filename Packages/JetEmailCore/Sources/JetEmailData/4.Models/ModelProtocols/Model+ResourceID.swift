//
//  File.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftData

public protocol UnifiedModel : PersistentModel  {
    associatedtype ResourceID : ResourceIDProtocol
    var resourceID : ResourceID { get }
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


