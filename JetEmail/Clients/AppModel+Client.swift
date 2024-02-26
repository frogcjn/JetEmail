//
//  Google+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Google
import Microsoft

extension AppModel {
    var googleClient: Google.Client  { Google.Client.shared }
}

extension AppModel {
    var microsoftClient: Microsoft.Client { get async throws { try await .shared }  }
}
