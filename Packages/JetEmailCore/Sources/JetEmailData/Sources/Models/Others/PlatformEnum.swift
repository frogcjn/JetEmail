//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailID
public typealias            Session = PlatformEnum<   AccountID, MicrosoftSession   , GoogleSession   >
public typealias    AccountResource = PlatformEnum<   AccountID, MicrosoftAccount   , GoogleAccount   >
public typealias MailFolderResource = PlatformEnum<MailFolderID, MicrosoftMailFolder, GoogleMailFolder>
public typealias    MessageResource = PlatformEnum<   MessageID, MicrosoftMessage   , GoogleMessage   >
