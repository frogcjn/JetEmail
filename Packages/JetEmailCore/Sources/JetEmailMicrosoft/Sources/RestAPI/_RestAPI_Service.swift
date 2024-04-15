//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

import struct Foundation.Data
import struct Foundation.KeyPathComparator

import struct Foundation.URL
import struct Foundation.URLRequest
import struct Foundation.URLQueryItem
import class  Foundation.URLSession

import  protocol JetEmailFoundation.AsyncSequenceOf
import typealias JetEmailFoundation.CodableValueType
import typealias JetEmailFoundation.CodableErrorType
import      enum JetEmailFoundation.JSON

import JetEmailData

extension MicrosoftSession {
    
    func _getMultipartData(url: URL, maxPageSize: Int? = nil) async throws -> Data {
        try await _getResponseDataForString(url: url, maxPageSize: maxPageSize)
    }
    
    func _getBatch<Value: Decodable & Sendable>(paths: [String], responseType: Value.Type = Value.self) async throws -> [Value] {
        let batchRequest: BatchRequest = .init(requests: paths.enumerated().map { offset, element in
                .init(id: String(offset), method: .get, url: element, headers: nil, body: nil)
        })
        let batchResponse: BatchResponse = try await _postResponse(url: client.endpointURL.appending(pathComponents: "$batch"), maxPageSize: nil, body: batchRequest)
        return try batchResponse.responses.map {
            guard let offset = Int($0.id), let body = $0.body else { throw MicrosoftAPIError.batchRequestWrongOffsetOrBody }
            return (offset: offset, element: try body.jsonData.decodeGraphJSON(Value.self))
        }.sorted(using: KeyPathComparator(\.offset)).map { $0.element as Value }
    }


    func _getValue<Value: Decodable & Sendable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> Value {
        try await _getResponse(url: url, maxPageSize: maxPageSize)
    }
    
    func _getValues<Value: Decodable & Sendable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> [Value] {
        var nextLink: URL? = url
        var values = [Value]()
        
        
        while let url = nextLink {
            let response: GraphCollectionResponse<Value> = try await _getResponse(url: url, maxPageSize: maxPageSize)
            values.append(contentsOf: response.values)
            nextLink = response.nextLink
        }

        return values
    }
    
    func _getValuesStream<Value: Sendable & Decodable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> (count: Int, stream: AsyncThrowingStream<[Value], Error>) {
        let url: URL =  url.appending(queryItems: [.count()])
        var firlstNextLink: URL?
        
        // get count
        let (count, firstValues) = try await {
            let response: GraphCollectionResponse<Value> = try await _getResponse(url: url, maxPageSize: maxPageSize)
            guard let count = response.count else { throw MicrosoftAPIError.collectionResponseNoCount }
            let values = response.values
            firlstNextLink = response.nextLink
            return (count, values)
        }()
        
        
        let (stream, continuation) = AsyncThrowingStream<[Value], Error>.makeStream()
        Task { [firstValues, firlstNextLink] in
            do {
                // get paging results
                
                continuation.yield(firstValues)
                await Task.yield()

                var nextLink: URL? = firlstNextLink
                
                while let url = nextLink {
                    let response: GraphCollectionResponse<Value> = try await _getResponse(url: url, maxPageSize: maxPageSize)
                    continuation.yield(response.values)
                    await Task.yield()
                    nextLink = response.nextLink
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        }
        return (count, stream)
    }

    func _patchItem<RequestBody: Encodable, Value: Decodable & Sendable>(
        url: URL, body: RequestBody, responseType: Value.Type = Value.self
    ) async throws -> Value {
        try await _patchResponse(url: url, body: body, responseType: responseType)
    }

    func _postItem<RequestBody: Encodable, Value: Decodable & Sendable>(url: URL, maxPageSize: Int? = nil, body: RequestBody, responseType: Value.Type = Value.self) async throws -> Value {
        try await _postResponse(url: url, maxPageSize: maxPageSize, body: body)
    }
    
    /*
    func _getValuesDeltaStream<Value: Sendable & Decodable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> AsyncThrowingStream<Delta<Value>, Error> {
                
        // get count
        let response: GraphCollectionResponse<Value> = try await _getResponse(url: url, maxPageSize: maxPageSize)
        let stream: AsyncThrowingStream<Delta<Value>, Error> = .init { continuation in Task { [delta = response.delta] in
            do {
                // get paging results
                
                continuation.yield(delta)
                await Task.yield()

                var nextLink: URL? = delta.nextLink
                
                while let url = nextLink {
                    let response: GraphCollectionResponse<Value> = try await _getResponse(url: url, maxPageSize: maxPageSize)
                    continuation.yield(response.delta)
                    await Task.yield()
                    nextLink = response.nextLink
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
        return stream
    }*/
}

// MARK: - Foundation: URLRequest, URLQueryItem

fileprivate extension MicrosoftSession {
        
    /*func _getResponseString(url: URL, maxPageSize: Int?) async throws -> String {
        try await URLRequest._get(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize).responseString
    }*/
    
    func _getResponseDataForString(url: URL, maxPageSize: Int?) async throws -> Data {
        try await URLRequest._get(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize).responseDataForString
    }
    
    func _getResponse<Value: Decodable & Sendable>(url: URL, maxPageSize: Int?, responseType: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._get(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize).responseDataForJSON.decodeGraphJSON(Value.self)
    }

    func _patchResponse<RequestBody: Encodable, Value: Decodable & Sendable>(url: URL, body: RequestBody, responseType: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._patch(url: url, authorization: refreshAuthorizationHeader, body: body).responseDataForJSON.decodeGraphJSON(Value.self)
    }

    func _postResponse<RequestBody: Encodable, Value: Decodable & Sendable>(url: URL, maxPageSize: Int?, body: RequestBody, responseType: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._post(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize, body: body).responseDataForJSON.decodeGraphJSON(Value.self)
    }
}

fileprivate extension URLRequest {
    
    static func _get(url: URL, authorization: String, maxPageSize: Int?) -> Self {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        if let maxPageSize {
            request.setValue("odata.maxpagesize=\(maxPageSize)", forHTTPHeaderField: "Prefer")
        }
        return request
    }

    private static func _patch(url: URL, authorization: String, bodyData: Data) -> Self {
        var request = URLRequest(url: url)
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.httpMethod = "PATCH"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")

        return request
    }

    private static func _post(url: URL, authorization: String, maxPageSize: Int?, bodyData: Data) -> Self {
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        if let maxPageSize {
            request.setValue("odata.maxpagesize=\(maxPageSize)", forHTTPHeaderField: "Prefer")
        }
        return request
    }

    static func _patch<T: Encodable>(url: URL, authorization: String, body: T) throws -> URLRequest {
        _patch(url: url, authorization: authorization, bodyData: try body.jsonData)
    }

    static func _post<T: Encodable>(url: URL, authorization: String, maxPageSize: Int?, body: T) throws -> URLRequest {
        _post(url: url, authorization: authorization, maxPageSize: maxPageSize, bodyData: try body.jsonData)
    }
    
    func _settingAuthorization(header: String) -> Self {
        var request = self
        request.setValue(header, forHTTPHeaderField: "Authorization")
        return request
    }
    
    var responseDataForJSON: Data { get async throws {
        let (data, response) = try await URLSession.shared.data(for: self)
        if !data.isEmpty {
            assert(response.mimeType == "application/json")
        }
        return data
    } }
    
    var responseDataForString: Data { get async throws {
        let (data, response) = try await URLSession.shared.data(for: self)
        assert(response.mimeType == "text/plain")
        return data
    } }

    var responseString: String { get async throws {
        try await responseDataForString.string
    } }

}

fileprivate extension Data {
    func decodeGraphJSON<T: Decodable>(_ type: T.Type) throws -> T {
        let result = Result { try decodeJSON(type) }
        switch result {
        case .failure(let failure):
            if let publicError = try? decodeJSON(GraphErrorResponse.self).error {
                throw MicrosoftAPIError.publicError(publicError)
            } else {
                throw failure
            }
        case .success(let success):
            return success
        }
    }
}

// https://learn.microsoft.com/en-us/graph/errors#error-resource-type
fileprivate struct GraphErrorResponse : Codable {
    let error: MicrosoftAPIError.Public
}

fileprivate struct GraphCollectionResponse<Value : Decodable & Sendable> : Decodable, Sendable {
    let values: [Value]

    let   context: URL?
    let     count: Int?
    let  nextLink: URL?
    let deltaLink: URL?
    
    enum CodingKeys : String, CodingKey {
        case   context = "@odata.context"
        case     count = "@odata.count"
        case  nextLink = "@odata.nextLink"
        case deltaLink = "@odata.deltaLink"
        case    values = "value"
    }
}

/*
fileprivate extension GraphCollectionResponse {
    var delta: Delta<Value> {
        .init(values: values, nextLink: nextLink, deltaLink: deltaLink)
    }
}

fileprivate struct Delta<Value: Sendable & Decodable> {
    let    values: [Value]
    let  nextLink: URL?
    let deltaLink: URL?
    
    func map<Transformed : Sendable>(_ transform: (Value) throws -> Transformed) rethrows -> Delta<Transformed> {
        .init(values: try values.map(transform), nextLink: nextLink, deltaLink: deltaLink)
    }
}
*/


// MARK: - URLQueryItem


extension URLQueryItem {
    static func top(_ value: Int) -> URLQueryItem {
        assert(value > 0)
        return .init(name: "$top", value: "\(value)")
    }
    
    static func skip(_ value: Int) -> URLQueryItem? {
        if value <= 0 { return nil }
        return .init(name: "$skip", value: "\(value)")
    }
    
    static func orderBy(name: String, _ order: Order? = nil) -> URLQueryItem {
        if let order {
            .init(name: "$orderby", value: "\(name) \(order.rawValue)")
        } else {
            .init(name: "$orderby", value: "\(name)")
        }
    }
    
    enum Order: String {
        case descending = "desc"
        case  ascending = "asc"
    }
    
    static func select(_ names: String...) -> URLQueryItem {
        .init(name: "$select", value: names.joined(separator: ","))
    }
    
    static let selectTotalItemCount: URLQueryItem = .select(
        "totalItemCount"
    )
    
    static let selectForMessagePreview: URLQueryItem = .select(
            "id",
            /*"subject",
            "createdDateTime",
            "lastModifiedDateTime",
            "receivedDateTime",
            "sentDateTime",
            "sender",
            "from",
            "toRecipients",
            "replyTo",
            "ccRecipients",
            "bccRecipients",*/
            "internetMessageHeaders",
            "bodyPreview"
        )
    
    static let selectForMessageBody: URLQueryItem = .select(
            "id",
            /*"subject",
            "createdDateTime",
            "lastModifiedDateTime",
            "receivedDateTime",
            "sentDateTime",
            "sender",
            "from",
            "toRecipients",
            "replyTo",
            "ccRecipients",
            "bccRecipients",*/
            "internetMessageHeaders",
            "bodyPreview",
            "body"
        )
    
    
    static func count(_ value: Bool = true) -> URLQueryItem {
        .init(name: "$count", value: "\(value)")
    }
    
    static func filter(ids: [String]) -> URLQueryItem {
        let ids = ids.map { "'\($0)'" }.joined(separator: ",")
        return  .init(name: "$filter", value: "id in (\(ids))")
    }
}

fileprivate struct BatchRequest: CodableValueType, Sendable {
    let requests: [Request] // no more than 20
    
    struct Request : CodableValueType, Sendable {
        let id: String
        let method: HTTPMethod
        let url: String
        let headers: [String: String]?
        let body: JSON?
    }
    
    enum HTTPMethod: String, CodableValueType, Sendable {
        case `get` = "GET"
        case post  = "POST"
    }
}

fileprivate struct BatchResponse: CodableValueType, Sendable {
    let responses: [Response]
    
    struct Response: CodableValueType, Sendable {
        let id: String
        let status: Int
        let headers: [String: String]?
        let body: JSON?
    }
}

extension MicrosoftClient {
    
    /*static var endpointURL: URL {
        MicrosoftClient.endpointURL
    }*/
    
    
}


extension URL {
    
    func appending(pathComponents: String..., queryItems: URLQueryItem?...) -> URL {
        var url = pathComponents.reduce(self) {
            $0.appending(path: $1)
        }
        if let queryItems = queryItems.compactMap({ $0 }).nilIfEmpty {
            url.append(queryItems: queryItems) // should not append empty queryItems
        }
        return url
    }
    
    func relative(pathComponents: String..., queryItems: URLQueryItem?...) -> String {
        let baseURL = self
        var url = pathComponents.reduce(baseURL) {
            $0.appending(path: $1)
        }
        if let queryItems = queryItems.compactMap({ $0 }).nilIfEmpty {
            url.append(queryItems: queryItems) // should not append empty queryItems
        }
        return try! url.relative(from: baseURL)
    }
    
    fileprivate func relative(from base: URL) throws -> String {
        // [scheme]://[user[:password]@][host][:port][path:/123]
        var baseURLString = base.absoluteString
        if baseURLString.hasSuffix("/") {
            baseURLString.removeLast()
        }
        
        let absluteString = absoluteString
        
        guard absluteString.hasPrefix(baseURLString) else {  throw MicrosoftAPIError.pathComponentNotTheSame }
        return String(absluteString.dropFirst(baseURLString.count))
    }
}
