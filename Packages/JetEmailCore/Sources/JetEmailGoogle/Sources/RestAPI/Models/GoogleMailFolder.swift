//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmailData

public struct GoogleMailFolder : GoogleProtocol, PlatformSpecificMailFolderProtocol {
    public typealias GeneralID = MailFolderID
    
    public let         id: GoogleMailFolderID
           let     _inner: _GoogleAPI.GoogleMailFolderInner
    
    public let systemName: MailFolderSystemName?
    
    public let       name: String? // adjust for google mailfolder path-name algrithm
    public let       path: String?
    
    init(id: GoogleMailFolderID, _inner: _GoogleAPI.GoogleMailFolderInner, name: String? = nil) {
        self.id         = id
        self._inner     = _inner
        self.systemName = _inner.systemName
        self.path       = _inner.name
        self.name       = name ?? _inner.name?.components(separatedBy: "/").last
    }
}
