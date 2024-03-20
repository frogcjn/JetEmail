//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public protocol GetMailFolderProtocol : GeneralIdentifiable where GeneralID : MailFolderIDProtocol {

}

extension PlatformEnum : MailFolderProtocol where
    Microsoft : MailFolderProtocol,
    Google: MailFolderProtocol,
    Microsoft.GeneralID == MailFolderID,
    Google.GeneralID == MailFolderID
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
