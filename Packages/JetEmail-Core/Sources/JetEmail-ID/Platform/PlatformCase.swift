//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmail_Foundation

public enum PlatformCase<Microsoft : CodableValueType, Google : CodableValueType> : CodableValueType {
    case microsoft(Microsoft)
    case    google(Google)
}
