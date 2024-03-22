//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import Foundation

public extension [MailFolder] {
    var sortedChildren: [MailFolder] { /*.sorted(using: KeyPathComparator(\.name))*/
        sorted { (mailFolder1: MailFolder, mailFolder2: MailFolder) in
            // seperate user folder and system folder: system folder < user folder
            if mailFolder1.isSystemFolder != mailFolder2.isSystemFolder { return mailFolder1.isSystemFolder }
            
            // both system folders: system order compare
            if let systemOlder0 = mailFolder1._systemName?.systemOrder, let systemOlder1 = mailFolder2._systemName?.systemOrder {
                return systemOlder0 < systemOlder1
            }
            
            // sort user folder by name
            return mailFolder1.localizedName.localizedStandardCompare(mailFolder2.localizedName) == .orderedAscending
        }
    }
    
    var sortedByChildIndex: [MailFolder] { /*.sorted(using: KeyPathComparator(\.name))*/
        sorted(using: KeyPathComparator(\._childIndex))
    }
}
