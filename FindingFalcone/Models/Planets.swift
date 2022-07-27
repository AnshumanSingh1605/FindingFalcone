//
//  Planets.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 21/07/22.
//

import Foundation

struct PlanetModel : Codable {
    let name : String
    let distance : Int
}

struct PlanetUIModel : Codable , Equatable {
    
    let planet : PlanetModel
    var vehicles : [String]?
    var isSelected : Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.planet.name == rhs.planet.name
    }

}

enum Planets {
    case DonLon, Enchai, Jebing , Sapir, Lerbin , Pingasor
}
