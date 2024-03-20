//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

public protocol UniqueID {
    var uniqueID: String { get }
}

/*extension String : UniqueID {
    public var uniqueID: String { self }
}*/

extension AccountID : UniqueID {
    public var uniqueID: String { "\(platform)/\(innerID)" }
}

extension MailFolderID : UniqueID {
    public var uniqueID: String { "\(platform)/\(accountID.innerID)/\(innerID)" }
}

extension MessageID : UniqueID {
    public var uniqueID: String { "\(platform)/\(accountID.innerID)/\(innerID)" }
}
