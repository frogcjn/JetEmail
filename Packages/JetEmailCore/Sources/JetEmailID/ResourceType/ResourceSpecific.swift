//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public protocol ResourceSpecific {
    static var resourceType: ResourceType { get }
}

public enum    AccountType : ResourceSpecific {
    public static var resourceType : ResourceType { .account    }
}
public enum MailFolderType : ResourceSpecific {
    public static var resourceType : ResourceType { .mailFolder }
}
public enum    MessageType : ResourceSpecific {
    public static var resourceType : ResourceType { .message    }
}
