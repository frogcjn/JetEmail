//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

extension [MailFolder] {
    func sidebarSorted() -> [MailFolder] { /*.sorted(using: KeyPathComparator(\.name))*/
        sorted {
            // isSystemFolder compare
            if $0.isSystemFolder != $1.isSystemFolder { return $0.isSystemFolder }
            
            if let systemOlder0 = $0.systemOrder, let systemOlder1 = $1.systemOrder {
                return systemOlder0 < systemOlder1
            }
            
            return $0.localizedName.localizedStandardCompare($1.localizedName) == .orderedAscending
        }
    }
}
