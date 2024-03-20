//
//  SplitView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct SplitView<Sidebar: View, Detail : View> : View {
    
    @ViewBuilder
    let sidebar: Sidebar
    
    @ViewBuilder
    let detail: Detail
    
    var body: some View {
        HStack {
            sidebar
                .padding()
                .containerRelativeFrame(.horizontal, count: 3, spacing: 0)
            
            detail
                .padding()
                .containerRelativeFrame(.horizontal, count: 3, span: 2, spacing: 0)
        }
    }
}
