//
//  Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import Foundation
import SwiftData // for @Model

/*

 */
@Model
final class Account : ModelItem {
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    private(set) var id: String
    private(set) var platform: String
    private(set) var platformID: String
    
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _platformID, _id)
        init(initialValue) {
            let (platform, platformID, string) = (initialValue.platform, initialValue.platformID, initialValue.string)
            _$backingData.setValue(forKey: \.platform,   to: platform.rawValue)
            _$backingData.setValue(forKey: \.platformID, to: platformID)
            _$backingData.setValue(forKey: \.id,         to: string)
            
            _platform   = _SwiftDataNoType()
            _platformID = _SwiftDataNoType()
            _id         = _SwiftDataNoType()
        }
        get {
            .init(platform: .init(rawValue: platform)!, platformID: platformID)
        }
        set {
            platform   = newValue.platform.rawValue
            platformID = newValue.platformID
            id = newValue.string
        }
    }
    
    var username: String
    
    var orderIndex: Int?
    // var isDeleted = false
    
    /// Account.root <-> MailFolder.account
    @Relationship(deleteRule: .nullify)
    var root: MailFolder?
    
    /// Account.mailFolders <->> MailFolder.account
    @Relationship(deleteRule: .cascade, inverse: \MailFolder.account)
    var mailFolders: [MailFolder] = []
    
    init(modelID: ModelID, username: String) {
        self.modelID            = modelID
        self.username           = username
        orderIndex = nil
    }
    
    var deleteMark = false { didSet {
            if deleteMark {
                mailFolders.forEach { $0.deleteMark = true }
            }
    } }
    
    var account: Account { self }
}


extension Account {
    
    var platformState: PlatformState {
        session != nil ? .hasSession : .noSession
    }
    
    enum PlatformState : String, Codable {
        case noSession // no account return from platform client cached account store
        case hasSession // no valid session return from platform client cached account
    }
    
    var isBusy: Bool {
        get { AttributesStore[modelID].isBusy }
        set { AttributesStore[modelID].isBusy = newValue }
    }
    
    var appModel: AppModel { .shared }
}

extension Account {
    @Observable
    final class AttributesStore {
        var rawValue = [ModelID: Attributes]()
        
        static subscript(modelID: ModelID) -> Attributes {
            get {
                if let properties = shared.rawValue[modelID] { return properties }
                let properties = Attributes()
                shared.rawValue[modelID] = properties
                return properties
            }
            set { shared.rawValue[modelID] = newValue }
        }
        
        struct Attributes {
            var isBusy = false
        }
    }
}

// print("id", id)
// 00000000-0000-0000-6a55-0f478222bc8f.9188040d-6c67-4c5b-b112-36a304b66dad

// print("username", username)
// frogcjn@163.com

//print("environment", account.environment)
// login.windows.net

//print("accountClaims", account.accountClaims ?? "nil")
/* accountClaims
 [
 "iss": https://login.microsoftonline.com/9188040d-6c67-4c5b-b112-36a304b66dad/v2.0,
 "typ": JWT,
 "name": Jiannan Cao,
 "nbf": 1707778799,
 "sub": AAAAAAAAAAAAAAAAAAAAAFBBmw7aZFmR6qoKcnR6VyU,
 "aud": 0ef42f9f-afc7-4463-bcbe-1c6dd4076b40,
 "oid": 00000000-0000-0000-6a55-0f478222bc8f,
 "tid": 9188040d-6c67-4c5b-b112-36a304b66dad,
 "alg": RS256,
 "aio": Dt1MF49paouIFLOU2r2EsHa3q571Q3fr48orGcNkes6*098xZE5g1JGfKqCaaSp0vMWq8o!dCfdFTZ4Tkhi9oyhrRokMISRJ1!YVRkM15ExuVLHYEwxD0CRs049jabY*3g77FFGlbGWNLlg3FNJJDls$,
 "exp": 1707865499,
 "ver": 2.0,
 "iat": 1707778799,
 "preferred_username": frogcjn@163.com,
 "kid": 2Spohh9y2me52nKrhai7GxWJibU
 ]
 
 [
 "exp": 1707865535,
 "oid": 00000000-0000-0000-595e-e8e1e1d67ee8,
 "iat": 1707778835, "aud": 0ef42f9f-afc7-4463-bcbe-1c6dd4076b40,
 "ver": 2.0,
 "kid": 2Spohh9y2me52nKrhai7GxWJibU,
 "typ": JWT,
 "iss": https://login.microsoftonline.com/9188040d-6c67-4c5b-b112-36a304b66dad/v2.0,
 "name": Jiannan Cao,
 "tid": 9188040d-6c67-4c5b-b112-36a304b66dad,
 "alg": RS256,
 "aio": DgtspLFl4Iq7B2QdTDOI234Y0gslL9AJuD!XcMpXDKvAimF*8ruJB7*D3R8X9LZu*MjeGvi8rEYgoO3QC2kpO9wDiz!tDgUycEsn9oBumy1T7z4hLlcOJtNvOticGS40SUnrZuIpg4spdEqc!sPdj2A$,
 "nbf": 1707778835,
 "sub": AAAAAAAAAAAAAAAAAAAAACnT5dtPQfpTWfaf7Cq4HVo,
 "preferred_username": frogcjn_hk@hotmail.com
 ]
 */

// print("homeAccountId", account.homeAccountId?.identifier ?? "nil", account.homeAccountId?.objectId ?? "nil", account.homeAccountId?.tenantId ?? "nil")
// identifier: 00000000-0000-0000-6a55-0f478222bc8f.9188040d-6c67-4c5b-b112-36a304b66dad
// objectID: 00000000-0000-0000-6a55-0f478222bc8f
// tenantId: 9188040d-6c67-4c5b-b112-36a304b66dad

// print("isSSOAccount", account.isSSOAccount)
// false

// print("tenantProfiles", account.tenantProfiles ?? "nil")
// nil


extension Session {
    
    var account: Account {
        get throws {
            switch self {
            case .microsoft(let microsoftSession): microsoftSession.account
            case .google(let googleSession): googleSession.account
            }
        }
    }
}
