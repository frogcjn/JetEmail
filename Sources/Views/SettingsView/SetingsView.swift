//
//  AppSettingsView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct SettingsView : View {
    
    var body: some View {
        TabView {
            AccountsTab()
                .tabItem { Label("Accounts", systemImage: "person.crop.circle.fill") }
            
            GeneralTab()
                .tabItem { Label("General", systemImage: "gearshape") }
        }
    }
}
