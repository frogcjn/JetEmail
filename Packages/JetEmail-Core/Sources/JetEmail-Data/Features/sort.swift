//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

extension [MailFolder] {
    func sidebarSorted() -> [MailFolder] { /*.sorted(using: KeyPathComparator(\.name))*/
        sorted { $0.localizedName.localizedStandardCompare($1.localizedName) == .orderedAscending }
    }
}
