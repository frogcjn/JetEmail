//
//  Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/21/24.
//

import Observation
import Google
import Microsoft

enum Session {
    case microsoft(Microsoft.Session)
    case google(Google.Session)
}
