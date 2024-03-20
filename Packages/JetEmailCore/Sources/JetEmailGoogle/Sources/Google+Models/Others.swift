//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import JetEmailData

extension GoogleMailFolder {
    public static func all(accountID: GoogleAccountID) -> GoogleMailFolder {
        let inner = GoogleMailFolderInner(id: .init("ALL"), name: "ALL")
        return inner.with(accountID: accountID, systemInfo: inner.systemInfo)
    }
}
