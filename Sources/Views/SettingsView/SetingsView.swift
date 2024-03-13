//
//  AppSettingsView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct SettingsView : View {
    
#if !os(macOS)
    @Environment(\.dismiss)
    var dismiss
#endif

    var body: some View {
        NavigationStack {

            TabView {
                
                    AccountsTab()


                    .tabItem { Label("Accounts", systemImage: "person.crop.circle.fill") }


                GeneralTab()
                    .tabItem { Label("General", systemImage: "gearshape") }
            }
#if !os(macOS)

                    .toolbar {
                        Button("close", systemImage: "xmark") {
                            dismiss()
                        }
                    }
#endif
        }
    }
}
