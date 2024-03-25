//
//  MailFolderAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import JetEmailData

public struct MicrosoftMailFolder : MicrosoftProtocol, PlatformSpecificMailFolderProtocol {
    public typealias GeneralID = MailFolderID
    
    public let         id: MicrosoftMailFolderID
           let     _inner: _MicrosoftAPI.MicrosoftMailFolderInner
    
    public let systemName: MailFolderSystemName?
    
    public let       name: String?
    
    init(id: MicrosoftMailFolderID, _inner: _MicrosoftAPI.MicrosoftMailFolderInner, _systemName: _MicrosoftAPI.MicrosoftMailFolderSystemName?, name: String?) {
        self.id         = id
        self._inner     = _inner
        self.systemName = _systemName?.systemName
        self.name       = name
    }
}
