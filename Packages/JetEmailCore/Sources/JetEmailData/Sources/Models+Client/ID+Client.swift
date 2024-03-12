//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import Foundation
import SwiftData
import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailID

// MARK: - MailFolder <-> Google, Microsoft

/*public extension MailFolder {
    convenience init(resource: MailFolderResource, in account: Account) {
        checkBackgroundThread()
        self.init(
            resourceID: resource.id,
            name      : resource.name,
            systemInfo: resource.systemInfo,
            in        : account
        )
        
        switch resource {
        case .microsoft(let microsoft):
            self._graph = try? microsoft.jsonString
        case .google(let google):
            self._google = try? google.jsonString
        }
    }
    
    /*var microsoft: MicrosoftMailFolder? {
        get {
            try? _graph?.decodeJSON(MicrosoftMailFolder.self)
        }
        set {
            guard let microsoft = newValue else { return }
            // self.id   = microsoft.id.general
            self.name = microsoft.inner.displayName ?? ""
            
            self._graph   = try? microsoft.jsonString
            self._google = nil
        }
    }*/
    func update(resource: MailFolderResource?) {
        guard let resource else { return }
        self.resourceID  = resource.id
        self.name        = resource.name
        self.systemInfo  = resource.systemInfo

        switch resource {
        case .microsoft(let microsoft):
            self._graph = try? microsoft.jsonString
        case .google(let google):
            self._google = try? google.jsonString
        }
    }
}*/
