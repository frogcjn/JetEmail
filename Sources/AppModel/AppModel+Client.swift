//
//  Google+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Google
import Microsoft
import os
import JetEmail_Data

@MainActor
extension AppItemModel where Context == AppModel, Item : DataModel {
    var appModel: AppModel { context }
    var logger: Logger { appModel.logger }
    /*var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }*/
}
