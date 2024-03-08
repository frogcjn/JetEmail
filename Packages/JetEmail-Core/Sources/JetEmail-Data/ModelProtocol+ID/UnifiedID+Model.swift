//
//  File.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//



import Microsoft
import Google

extension Account: DataModel {
    public typealias MicrosoftID = Microsoft.ID
    public typealias GoogleID = Google.ID
    public typealias ID = UnifiedID<Account>
}

extension MailFolder: DataModel {
    public typealias GoogleID = Google.MailFolder.ID
    public typealias MicrosoftID = Microsoft.MailFolder.ID
    public typealias ID = UnifiedID<MailFolder>
}

extension Message: DataModel {
    public typealias GoogleID = Google.Message.ID
    public typealias MicrosoftID = Microsoft.Message.ID
    public typealias ID = UnifiedID<Message>
}
