//
//  JSON.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation

extension String {
    func jsonDecode<T: Decodable>(_ type: T.Type) throws -> T {
        guard let data = data(using: .utf8) else { throw FoudnationError.stringToData}
        return try data.jsonDecode(type)
    }
}

extension Data {
    func jsonDecode<T: Decodable>(_ type: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
}

extension Result {
    func catching<T>(_ closure: @escaping () async throws -> T) async -> Result<T, Error> {
        await Task { try await closure() }.result
    }
}

extension Encodable {
    var jsonString: String {
        get throws {
            guard let string = String(data: try jsonData, encoding: .utf8) else { throw FoudnationError.dataToString }
            return string
        }
    }
}

extension Encodable {
    var jsonData: Data {
        get throws {
            try JSONEncoder().encode(self)
        }
    }
    /*
     func jsonData() throws -> Data {
         try JSONEncoder().encode(self)
     }
     */
}


extension Date {
    func formattedRelative() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: .now)
        switch components.day ?? 0 {
        case 3...:
            return self.formatted(.dateTime.day(.defaultDigits).month(.defaultDigits).year(.defaultDigits))
        default:
            return self.formatted(.relative(presentation: .named)/*.locale(.current)*/)
        }
    }
}

import SwiftData

extension PersistentModel {
    func to(_ modelContext: ModelContext) throws -> Self {
        guard let transfered = modelContext.model(for: persistentModelID) as? Self else {
            throw SwiftDataError.noModelInstance(id: String(describing: persistentModelID.id), in: modelContext)
        }
        return transfered
    }
}

extension Sequence where Element: PersistentModel {
    func to(_ modelContext: ModelContext) throws -> [Element] {
        try map { try $0.to(modelContext) }
    }
}



extension Collection {
    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}





