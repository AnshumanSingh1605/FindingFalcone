//
//  APIErrors.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 24/07/22.
//

import Foundation

enum APIErrors : Error {
    
    case invalidResponse
    case invalidURL
    case invalidData
    case custom(String)
    
    case limitReached(String)
    case invalidInput(String)
    
    var message : String {
        switch self {
        case .invalidResponse :         return "Invalid Response"
        case .invalidURL:               return "Invalid URL : \n Please check your URL"
        case .invalidData:              return "Oops! Unable to parse response data"
        case .limitReached(let title):  return "Oops! Max limit reached for \(title)"
        case .custom(let error):        return "\(error)"
        case .invalidInput(let message):return message
        //default :                       return "Invalid Response"
        }
    }
}
