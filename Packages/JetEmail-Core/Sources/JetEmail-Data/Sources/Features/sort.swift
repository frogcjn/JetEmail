//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import Foundation

public extension [MailFolder] {
    var sortedInParentMailFolder: [MailFolder] { /*.sorted(using: KeyPathComparator(\.name))*/
        sorted { (mailFolder1: MailFolder, mailFolder2: MailFolder) in
            // seperate user folder and system folder: system folder < user folder
            if mailFolder1._isSystemFolder != mailFolder2._isSystemFolder { return mailFolder1._isSystemFolder }
            
            // both system folders: system order compare
            if let systemOlder0 = mailFolder1._systemOrder, let systemOlder1 = mailFolder2._systemOrder {
                return systemOlder0 < systemOlder1
            }
            
            // sort user folder by name
            return mailFolder1.localizedName.localizedStandardCompare(mailFolder2.localizedName) == .orderedAscending
        }
    }
    
    var sortedInParentMailFolderUsingIndex: [MailFolder] { /*.sorted(using: KeyPathComparator(\.name))*/
        sorted(using: KeyPathComparator(\._childIndex))
    }
}