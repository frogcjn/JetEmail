//
//  MailFolder.Others.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import Foundation

extension MSGraph {
    
    /*
     The date and time the message was created.
     The date and time information uses ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z.
     */
    struct DateTimeOffset: RawRepresentable, Codable {
        static let dateFormatter = ISO8601DateFormatter()
        let date: Date
        let rawValue: String
        init?(rawValue: String) {
            guard let date = Self.dateFormatter.date(from: rawValue) else { return nil }
            self.rawValue = rawValue
            self.date = date
        }
    }

    // https://learn.microsoft.com/en-us/graph/api/resources/itembody
    
    struct ItemBody : Codable {
        let content: String?
        let contentType: ContentType?
        
        enum ContentType : String, Codable {
            case text
            case html
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/recipient
    
    struct Recipient : Codable {
        let emailAddress: EmailAddress?
        var nameAndAddress: String {
            emailAddress?.nameAndAddress ?? "nil"
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/emailaddress
    
    struct EmailAddress: Codable {
        let address: String?
        let name: String?
        
        var nameAndAddress: String {
            (name ?? "nil") + " " + "<\(address ?? "nil")>"
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/followupFlag
    
    struct FollowupFlag : Codable {
        // The date and time that the follow-up was finished.
        let completedDateTime: DateTimeTimeZone?
        /**
         * The date and time that the follow-up is to be finished. Note: To set the due date, you must also specify the
         * startDateTime; otherwise, you get a 400 Bad Request response.
         */
        let dueDateTime: DateTimeTimeZone?
        // The status for follow-up for an item. Possible values are notFlagged, complete, and flagged.
        let flagStatus: FollowupFlagStatus
        // The date and time that the follow-up is to begin.
        let startDateTime: DateTimeTimeZone?
        
        enum FollowupFlagStatus : String, Codable {
            case notFlagged, complete, and
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/datetimetimezone
    
    struct DateTimeTimeZone : Codable {
        let dataTime: String
        let timeZone: String
    }
    
    struct Importance : Codable {
        
    }
    
    struct InferenceClassificationType : Codable {
        
    }
    
    struct InternetMessageHeader : Codable {
        
    }
}

extension MSGraph.EmailAddress : Equatable {
    
}

/*

protocol MicrosoftGraphEntity {
    // The unique identifier for an entity. Read-only.
    var id: MSGraph.Message.ID { get }
}

protocol MicrosoftOutlookItem : MicrosoftGraphEntity {
    // The categories associated with the item
    var categories: [String]? { get }
    /**
     * Identifies the version of the item. Every time the item is changed, changeKey changes as well. This allows Exchange to
     * apply changes to the correct version of the object. Read-only.
     */
    var changeKey: String? { get }
    /**
     * The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example,
     * midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
     */
    var createdDateTime: Date? { get }
    /**
     * The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example,
     * midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
     */
    var lastModifiedDateTime: Date? { get }
}
*/
