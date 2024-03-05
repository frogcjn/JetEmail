//
//  MailFolderCell.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct MailFolderCell : View {
    
    @Environment(MailFolder.self)
    var mailFolder
    
    var body: some View {
        HStack {
            Image(systemName: mailFolder.systemImage)
                .frame(width: 8, height: 8)
                .foregroundStyle(.tint)
            Text(mailFolder.localizedName)
        }.padding(.horizontal, 5)
    }
}
