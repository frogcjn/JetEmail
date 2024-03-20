//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import struct Foundation.LocalizedStringResource
import JetEmailData

fileprivate extension GoogleMailFolderInner {
    var isSystemFolder: Bool {
        guard let type = type else { return false }
        return type == .system
    }
    
    
}

extension GoogleMailFolderInner {
    var systemInfo: MailFolderSystemInfo? {
        guard isSystemFolder else { return nil }
        guard let systemName = GoogleMailFolderSystemName(rawValue: id) else { return nil }
        return systemName.systemInfo
    }
}

extension GoogleMailFolder {
    public static func all(accountID: GoogleAccountID) -> GoogleMailFolder {
        let inner = GoogleMailFolderInner(id: .init("ALL"), name: "ALL")
        return inner.with(accountID: accountID, systemInfo: inner.systemInfo)
    }
}

