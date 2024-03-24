//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import JetEmailData

extension GoogleMailFolder {
    static func all(accountID: GoogleAccountID) -> GoogleMailFolder {
        let inner = _GoogleAPI.GoogleMailFolderInner(id: .init("ALL"), name: "ALL")
        return inner.with(accountID: accountID)
    }
}
