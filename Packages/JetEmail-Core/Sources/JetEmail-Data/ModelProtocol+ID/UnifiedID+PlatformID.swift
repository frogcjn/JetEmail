//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/7/24.
//

import Google
import Microsoft

// MARK: - Account.ID <- Google, Microsoft

public extension Microsoft.ID {
    var unifiedAccountID: JetEmail_Data.Account.ID { .microsoft(self) }
}

public extension Microsoft.MSALAccount {
    var unifiedAccountID: JetEmail_Data.Account.ID { get throws { try id.unifiedAccountID } }
}

public extension Microsoft.MSALSession {
    var unifiedAccountID: JetEmail_Data.Account.ID { get throws { try account.unifiedAccountID } }
}

public extension Microsoft.Session {
    var unifiedAccountID: JetEmail_Data.Account.ID { accountID.unifiedAccountID }
}

public extension Google.ID {
    var unifiedAccountID: JetEmail_Data.Account.ID { .google(self) }
}

public extension Google.GTMSession {
    var unifiedAccountID: JetEmail_Data.Account.ID { get throws { try accountID.unifiedAccountID } }
}

public extension Google.Session {
    var unifiedAccountID: JetEmail_Data.Account.ID { accountID.unifiedAccountID }
}

// MARK: - MailFolder.ID <- Google, Microsoft

public extension Microsoft.MailFolder.ID {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        .init(platform: .microsoft, platformID: rawValue)
    }
}

public extension Microsoft.MailFolder {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        id.unifiedID
    }
}

public extension Google.MailFolder.ID {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        .init(platform: .google, platformID: rawValue)
    }
}

public extension Google.MailFolder {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        id.unifiedID
    }
}

// MARK: - Message.ID <- Google, Microsoft

public extension Microsoft.Message.ID {
    var unifiedID: JetEmail_Data.Message.ID {
        .init(platform: .microsoft, platformID: rawValue)
    }
}

public extension Microsoft.Message {
    var unifiedID: JetEmail_Data.Message.ID {
        id.unifiedID
    }
}

public extension Google.Message.ID {
    var unifiedID: JetEmail_Data.Message.ID {
        .init(platform: .google, platformID: rawValue)
    }
}

public extension Google.Message {
    var unifiedID: JetEmail_Data.Message.ID {
        id.unifiedID
    }
}

// MARK: - Account|MailFolder|Message -> Google, Microsoft

public extension JetEmail_Data.UnifiedID {
    var microsoftID: Model.MicrosoftID? {
        guard case .microsoft(let microsoftID) = self else { return nil }
        return microsoftID
    }
    
    var googleID: Model.GoogleID? {
        guard case .google(let googleID) = self else { return nil }
        return googleID
    }
}

public extension DataModel where ID == UnifiedID<Self> {
    var microsoftID: MicrosoftID? { id.microsoftID }
    var    googleID:    GoogleID? { id.googleID    }
}
