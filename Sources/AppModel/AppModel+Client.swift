//
//  Google+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import os
import JetEmailData

@MainActor
extension AppItemModel where Context == AppModel, Item : UnifiedModel {
    var appModel: AppModel { context }
    var logger: Logger { appModel.logger }
    /*var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }*/
}
