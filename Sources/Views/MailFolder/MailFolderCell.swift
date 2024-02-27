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
        Text(mailFolder.name)
    }
}
