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
}
