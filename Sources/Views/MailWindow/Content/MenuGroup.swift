//
//  AppMenu.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftUI

struct MenuGroup<Data : RandomAccessCollection, Label : View, Leaf : View> : View where Data.Element : Identifiable {
    let data: Data
    
    let children: KeyPath<Data.Element, Data?>
    
    @Binding
    var selection: Data.Element?
    
    @ViewBuilder
    let content: (Data.Element) -> Leaf

    @ViewBuilder
    let primaryLabel: () -> Label
    
    let action: () -> Void
    
    var body: some View {
        Menu(
            content: {
                ForEach(data) { element in
                    _MenuGroup(
                          element: element,
                         children: children,
                        selection: $selection,
                          content: content,
                           action: action
                    )
                }
            },
            label: primaryLabel,
            primaryAction: action
        )
    }
}


fileprivate struct _MenuGroup<Data: RandomAccessCollection, Leaf : View> : View where Data.Element : Identifiable {
    let element: Data.Element
    
    let children: KeyPath<Data.Element, Data?>
    
    @Binding
    var selection: Data.Element?
    
    @ViewBuilder
    let content: (Data.Element) -> Leaf
    
    let action: () -> Void
    
    
    var body: some View {
        if let data = element[keyPath: children] {
            Menu { menuContent(data) }
            label: { buttonLabel(element) }
            primaryAction:{ buttonAction(element) }
        } else {
            button(element)
        }
    }
    
    private func menuContent(_ data: Data) -> some View {
        ForEach(data) { element in
            if element[keyPath: children] == nil {
                button(element)
            } else {
                submenu(element)
            }
        }
    }
    
    private func submenu(_ element: Data.Element) -> some View {
        _MenuGroup(
              element: element,
             children: children,
            selection: $selection,
              content: content,
               action: action
        )
    }
    
    private func button(_ element: Data.Element) -> some View {
        Button { buttonAction(element) }
        label: { buttonLabel(element) }
    }
    
    private func buttonLabel(_ element: Data.Element) -> Leaf {
        content(element)
    }
    
    private func buttonAction(_ element: Data.Element) {
        selection = element
        action()
    }
}

/*
fileprivate struct __AppMenu<Data : RandomAccessCollection, Leaf : View> : View where Data.Element : Identifiable {
    typealias SelectionValue = Data.Element
    
    let element: Data.Element
    
    let children: KeyPath<Data.Element, Data?>
    
    @Binding
    var selection: Data.Element?
    
    @ViewBuilder
    let content: (Data.Element) -> Leaf
    
    let action: () -> Void
    
    var body: some View {
        AppMenu(
               element: element,
              children: children,
             selection: $selection,
               content: content,
                action: action
        )
    }
}
*/

//Toggle(isOn: $isSelectedToMove) {
//HStack {

/*
.labelStyle(.titleAndIcon)
*/


/*ForEach((message.mailFolder.account.root?.children ?? []).filter { !$0.deleteMark }) { mailFolder in
    Button(mailFolder.localizedName, systemImage: mailFolder.systemImage) {
        
    }
    if mailFolder.children {
        
    }
}

/*OutlineGroup((account.root?.children ?? []).filter { !$0.deleteMark }, children: \.children.nilIfEmpty) { mailFolder in
    
    Button(mailFolder.localizedName, systemImage: mailFolder.systemImage) {
        
    }
}*/

}
}*/

/*
Image(systemName: "xmark.circle.fill").tag(MailFolder?.none)
/*OutlineGroup((message.mailFolder.account.root?.children ?? []).filter { !$0.deleteMark }, children: \.children.nilIfEmpty) { item in
    MailFolderCell()
        .itemModel(item)
        .tag(item) // selection tag
}*/

ForEach((account.root?.children ?? []).filter { !$0.deleteMark }, id: \.children.nilIfEmpty) { mailFolder in
    Label(mailFolder.localizedName, systemImage: mailFolder.systemImage).tag(Optional(mailFolder))
}



/**/
} label: {

}
.labelStyle(.titleAndIcon)*/

//}
//}
