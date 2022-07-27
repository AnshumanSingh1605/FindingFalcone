//
//  APIResponse.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import Foundation

struct TokenModel : Codable {
    let token : String
}

struct FailureResponse : Codable {
    let error : String?
    let status : String?
}

struct FindAPIResponse : Codable {

    let name : String
    let status : String
    
    enum CodingKeys: String, CodingKey {
        case name = "planet_name"
        case status
    }
}

struct FindRequestBodyModel : Encodable {
    
    let token : String
    let planets : [String]
    let vehicles : [String]
    
    enum CodingKeys: String, CodingKey {
        case planets = "planet_names"
        case vehicles = "vehicle_names"
        case token
    }
}

struct FindRequestResponseUIModel : Codable {
    
    let planet : String?
    let status : String?
    let timeTaken : Int?
    
    enum CodingKeys: String, CodingKey {
        case planet = "planet_name"
        case status , timeTaken 
    }
}
