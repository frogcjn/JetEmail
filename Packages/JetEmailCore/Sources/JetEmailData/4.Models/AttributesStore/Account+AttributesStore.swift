//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

@MainActor
public extension Account {
    var isBusy: Bool {
        get { resourceID.isBusy }
        set { resourceID.isBusy = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { resourceID.loadedMailFolder }
        set { resourceID.loadedMailFolder = newValue }
    }
}
