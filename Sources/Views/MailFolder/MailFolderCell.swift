//
//  MailFolderCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Data

struct MailFolderCell : View {
    
    @Environment(MailFolder.self)
    var mailFolder
    
    var body: some View {
        Label(mailFolder.localizedName, systemImage: mailFolder.systemImage)
    }
}
