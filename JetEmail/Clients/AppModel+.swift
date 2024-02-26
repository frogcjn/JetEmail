//
//  AppModel+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/19/24.
//

import Foundation
import SwiftData
import os
import Google
import Microsoft

extension AppItemModel where Context == AppModel, Item : ModelItem {
    var appModel: AppModel { context }
    var logger: Logger { appModel.logger }
    var microsoftClient: Microsoft.Client { get async throws { try await appModel.microsoftClient } }
    var    googleClient: Google.Client { get { appModel.googleClient } }

    var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }
}
