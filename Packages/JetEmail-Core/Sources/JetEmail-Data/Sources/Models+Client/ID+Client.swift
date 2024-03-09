//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import Foundation
import SwiftData
import Google
import Microsoft
import JetEmail_Foundation

// MARK: - MailFolder <-> Google, Microsoft

public extension JetEmail_Data.MailFolder {
    convenience init(microsoft: Microsoft.MailFolder, in account: JetEmail_Data.Account) {
        self.init(
            modelID: microsoft.id.unifiedID(accountID: account.id.microsoftID!),
            name   : microsoft.displayName ?? "",
            in     : account
        )
        
        self._graph = try? microsoft.jsonString
    }
    
    convenience init(google: Google.MailFolder, in account: JetEmail_Data.Account) {
        self.init(
            modelID: google.id.unifiedID(accountID: account.id.googleID!),
            name   : google.name ?? "",
            in     : account
        )
        
        self._google = try? google.jsonString
    }
    
    var microsoft: Microsoft.MailFolder? {
        get {
            try? _graph?.decodeJSON(Microsoft.MailFolder.self)
        }
        set {
            guard let graph = newValue else { return }
            self.id  = graph.id.unifiedID(accountID: account.id.microsoftID!)
            self.name     = graph.displayName ?? ""
            
            self._graph   = try? graph.jsonString
            self._google = nil
        }
    }
    
    var google: Google.MailFolder? {
        get {
            try? _google?.decodeJSON(Google.MailFolder.self)
        }
        set {
            guard let google = newValue else { return }
            self.id = google.id.unifiedID(accountID: account.id.googleID!)
            self.name = google.name ?? ""
            self._google = try? google.jsonString
            self._graph = nil
        }
    }
}
