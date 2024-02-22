//
//  Model+GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/18/24.
//

// MARK: - Model <-> MSGraph

extension Account {
    convenience init(google: Google.Account, orderIndex: Int) throws {
        self.init(
            modelID: google.modelID,
            username: google.username,
            orderIndex: orderIndex
        )
    }
    
    func update(google: Google.Account, deleteMark: Bool = false) {
        if self.modelID == google.modelID && self.username == google.username && self.deleteMark == deleteMark { return }
        self.deleteMark = deleteMark
        self.modelID  = google.modelID
        self.username = google.username
    }
    /*
    var googleAccount: Google.Account? {
        @available(macOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        @available(iOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        get {
            nil // should use graph(_:)
            // self.graph
        }
        set {
            guard let google = newValue else { return }
            self.modelID  = google.modelID
            self.username = google.username
        }
    }*/
}

