//
//  Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/21/24.
//

import Observation

enum Session {
    case microsoft(Microsoft.Session)
    case google(Google.Session)
}

