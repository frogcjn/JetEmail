//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

extension [MailFolder] {
    func sidebarSorted() -> [MailFolder] { /*.sorted(using: KeyPathComparator(\.name))*/
        sorted {
            // seperate user folder and system folder: system folder < user folder
            if $0.isSystemFolder != $1.isSystemFolder { return $0.isSystemFolder }
            
            // both system folders: system order compare
            if let systemOlder0 = $0.systemOrder, let systemOlder1 = $1.systemOrder {
                return systemOlder0 < systemOlder1
            }
            
            // sort user folder by name
            return $0.localizedName.localizedStandardCompare($1.localizedName) == .orderedAscending
        }
    }
}
