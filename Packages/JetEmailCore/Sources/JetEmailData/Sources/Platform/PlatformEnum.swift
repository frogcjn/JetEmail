//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailID
public typealias             Client = PlatformEnum<MicrosoftClient    , GoogleClient    >
public typealias            Session = PlatformEnum<MicrosoftSession   , GoogleSession   >
public typealias    AccountResource = PlatformEnum<MicrosoftAccount   , GoogleAccount   >
public typealias MailFolderResource = PlatformEnum<MicrosoftMailFolder, GoogleMailFolder>
public typealias    MessageResource = PlatformEnum<MicrosoftMessage   , GoogleMessage   >
