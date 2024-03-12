//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public protocol GetMailFolderProtocol : GeneralIdentifiable where GeneralID : MailFolderIDProtocol {
          var name: String? { get }
    var systemInfo: MailFolderSystemInfo? { get }
}

extension PlatformEnum : GetMailFolderProtocol where
    Microsoft : GetMailFolderProtocol,
    Google : GetMailFolderProtocol, GeneralID : MailFolderIDProtocol
{
    public var name: String? {
        switch self {
        case .microsoft(let platform): platform.name
        case    .google(let platform): platform.name
        }
    }
    
    public var systemInfo: MailFolderSystemInfo? {
        switch self {
        case .microsoft(let platform): platform.systemInfo
        case    .google(let platform): platform.systemInfo
        }
    }
}
