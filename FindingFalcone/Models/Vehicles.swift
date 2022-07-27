//
//  Vehicles.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 21/07/22.
//

import Foundation

struct VehicleModel : Codable {
    let name : String
    var total_no : Int
    let max_distance : Int
    let speed : Int
}

enum Vehicles {
    case pod , rocket , shuttle , ship
}

class Post: Codable {
    
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }

    init(userID: Int, id: Int, title: String, body: String) {
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
}

