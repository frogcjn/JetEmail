//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

import JetEmailData
import JetEmailID

@MainActor
public extension Account {
    var isBusy: Bool {
        get { resourceID.isBusy }
        set { resourceID.isBusy = newValue }
    }
    
    var idToWellKnownFolderName: [MailFolderID: MicrosoftWellKnownFolderName]? {
        get { resourceID.idToWellKnownFolderName }
        set { resourceID.idToWellKnownFolderName = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { resourceID.loadedMailFolder }
        set { resourceID.loadedMailFolder = newValue }
    }
}
