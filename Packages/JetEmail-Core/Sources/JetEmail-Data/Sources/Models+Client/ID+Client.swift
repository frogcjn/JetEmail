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
    convenience init(platformCase: PlatformCase<MicrosoftMailFolder, GoogleMailFolder>, in account: JetEmail_Data.Account) {
        checkBackgroundThread()
        let info = MailFolderInfo(
              isSystemFolder: platformCase.isSystemFolder,
                 systemOrder: platformCase.systemOrder,
            nameLocalizedKey: platformCase.nameLocalizedKey,
                 systemImage: platformCase.systemImage
        )
        switch platformCase {
        case .microsoft(let microsoft):
            self.init(
                modelID: microsoft.id.general,
                name   : microsoft.inner.displayName ?? "",
                info   : info,
                in     : account
            )
            self._graph = try? microsoft.jsonString
        case .google(let google):
            self.init(
                modelID: google.id.general,
                name   : google.data.name ?? "",
                info   : info,
                in     : account
            )
            self._google = try? google.jsonString
        }
        
    }
    
    var microsoft: MicrosoftMailFolder? {
        get {
            try? _graph?.decodeJSON(MicrosoftMailFolder.self)
        }
        set {
            guard let microsoft = newValue else { return }
            self.id   = microsoft.id.general
            self.name = microsoft.inner.displayName ?? ""
            
            self._graph   = try? microsoft.jsonString
            self._google = nil
        }
    }
    
    var google: GoogleMailFolder? {
        get {
            try? _google?.decodeJSON(GoogleMailFolder.self)
        }
        set {
            guard let google = newValue else { return }
            self.id = google.id.general
            self.name = google.data.name ?? ""
            self._google = try? google.jsonString
            self._graph = nil
        }
    }
}
