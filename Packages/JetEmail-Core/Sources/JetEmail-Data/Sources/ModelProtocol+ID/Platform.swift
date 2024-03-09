//
//  Platform.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmail_Foundation

public enum Platform : String {
    case microsoft
    case google
}

extension Platform: CodableValueType {}
