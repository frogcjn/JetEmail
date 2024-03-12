//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailID

public typealias MailFolderResource = PlatformEnum<MailFolderID, MicrosoftMailFolder, GoogleMailFolder>
public typealias MessageResource    = PlatformEnum<   MessageID, MicrosoftMessage   , GoogleMessage>
