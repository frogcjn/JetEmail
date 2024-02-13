//
//  AppSettings.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI
import MSAL
import ObservableUserDefault

@Observable
class AppSettings {
    // Show with Dark Background
    @ObservableUserDefault(.init(key: "isShowingWithDarkBackground", defaultValue: true, store: .standard))
    @ObservationIgnored
    var isShowingWithDarkBackground: Bool
}
