//
//  MailFolder.Others.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import Foundation

extension Microsoft.Graph {
    
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

/*

protocol MicrosoftGraphEntity {
    // The unique identifier for an entity. Read-only.
    var id: Microsoft.Graph.Message.ID { get }
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

/*
extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: MSALAPIMailFolderID) {
        appendInterpolation(value.rawValue)
    }
}
*/

enum MSALAPIError : Error {
    case description(String)
}

struct GraphCollectionResponse<Value : Decodable> : Decodable {
    let value: [Value]

    let  context: URL?
    let    count: Int?
    let nextLink: URL?
    
    enum CodingKeys : String, CodingKey {
        case  context = "@odata.context"
        case    count = "@odata.count"
        case nextLink = "@odata.nextLink"
        case    value
    }
}

// https://learn.microsoft.com/en-us/graph/errors#error-resource-type
struct GraphErrorResponse : Codable {
    let error: Microsoft.Graph.PublicError
}

// typealias JSON<T: Any> = [String: T] where T: Codable

extension Microsoft.Graph {
    struct PublicError : Codable, Error {
        let code: String?
        let message: String?
        let innerError: JSON?
        let details: [JSON]?
    }
}

func handleError(from data: Data) throws -> Microsoft.Graph.PublicError {
    try JSONDecoder().decode(Microsoft.Graph.PublicError.self, from: data)
}

func handleGraphResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    let result = Result{ try JSONDecoder().decode(type.self, from: data) }
    switch result {
    case .failure(let failure):
        if let error = try? JSONDecoder().decode(GraphErrorResponse.self, from: data).error {
            throw error
        } else {
            throw failure
        }
    case .success(let success):
        return success
    }
}



extension URLQueryItem {
    static func top(_ value: Int) -> URLQueryItem {
        assert(value > 0)
        return .init(name: "$top", value: "\(value)")
    }
    
    static func orderBy(name: String, _ order: Order? = nil) -> URLQueryItem {
        if let order {
            .init(name: "$orderby", value: "\(name) \(order)")
        } else {
            .init(name: "$orderby", value: "\(name)")
        }
    }
    
    enum Order: String {
        case descending = "desc"
        case ascending = "asc"
    }
    
    static func count(_ value: Bool = true) -> URLQueryItem {
        .init(name: "$count", value: "\(value)")
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation<T: RawRepresentable>(_ value: T) where T.RawValue == String {
        appendInterpolation(value.rawValue)
    }
}


struct MailFoldersCreateRequestBody : Codable {
    let displayName: String
    let isHidden: Bool?
}

extension Encodable {
    func jsonData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}



