//
//  AppSettings.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI
import ObservableUserDefault
import JetEmail_Data

@MainActor
@Observable
class SettingsModel {
    
    var selectedAccount: Account?

    // Feature: Message - Dark Background
    @ObservableUserDefault(.init(key: "isShowingWithDarkBackground", defaultValue: false, store: .standard))
    @ObservationIgnored
    var isShowingWithDarkBackground: Bool
    
    #if !os(macOS)
    var isPresenting = false
    #endif
}
