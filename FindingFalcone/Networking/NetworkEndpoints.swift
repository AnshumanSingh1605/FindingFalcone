//
//  NetworkEndpoints.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 21/07/22.
//

import Foundation

enum NetworkEndpoints  {
        
    case token
    case getVehicles
    case getPlanets
    case find(FindRequestBodyModel)
    
    var path : String {
        switch self {
        case .token:        return "token"
        case .getVehicles:  return "vehicles"
        case .getPlanets:   return "planets"
        case .find:         return "find"
        }
    }
}

extension NetworkEndpoints : Endpoints {
    
    var headers: [String : Any]? {
        var headers = [String : Any]()
        headers[Constants.Defaults.key_accept] = Constants.Defaults.contentType
        switch self {
        case .token :
            headers[Constants.Defaults.key_contentType] = Constants.Defaults.plainText
        default:
//            if let token = UserDefaultManager.shared.authToken {
//                if token != Constants.Defaults.token {
//                    headers[Constants.Defaults.key_authorization] = token
//                }
//            }
            headers[Constants.Defaults.key_contentType] = Constants.Defaults.contentType
        }
        return headers
    }
    
    
    var url: String {
        switch self {
            default:   return baseUrl + self.path
        }
    }
    
    var authenticationToken: String? {
        return nil
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .find(let body):       return try? JSONEncoder().encode(body)
        default :                   return nil
        }
    }
    
    var method: String {
        switch self {
        case .getVehicles ,.getPlanets:
            return "GET"
        case .token,.find:
            return "POST"
        }
    }
}
