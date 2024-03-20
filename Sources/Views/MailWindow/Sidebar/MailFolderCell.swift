//
//  MailFolderCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmailData // for MailFolder

struct MailFolderCell : View {
    
    @Environment(MailFolder.self)
    var mailFolder
    
    var body: some View {
        Label(mailFolder.localizedName, systemImage: mailFolder.systemImage)
    }
}
