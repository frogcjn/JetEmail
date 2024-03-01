//
//  Google+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Google
import Microsoft
import os

extension AppModel {
    var googleClient: Google.Client  { Google.Client.shared }
}

extension AppModel {
    var microsoftClient: Microsoft.Client { get async throws { try await .shared }  }
}

extension AppItemModel where Context == AppModel, Item : ModelItem {
    var appModel: AppModel { context }
    var logger: Logger { appModel.logger }
    var microsoftClient: Microsoft.Client { get async throws { try await appModel.microsoftClient } }
    var    googleClient: Google.Client { get { appModel.googleClient } }

    /*var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }*/
}
