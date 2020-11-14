//
//  Game.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import Foundation

class Games: Codable {
    private enum CodingKeys:String,CodingKey {
        case results = "results"
        case next = "next"
        case previous = "previous"
        
    }
    
    
    var results:[Game]
    var next:String?
    var previous:String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([Game].self, forKey: .results)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.previous = try container.decodeIfPresent(String.self, forKey: .previous)
    }
}



class Game: Codable {
    private enum CodingKeys:String,CodingKey {
        case id = "id"
        case name = "name"
        case released = "released"
        case background_image = "background_image"
        case rating = "rating"
        case rating_top = "rating_top"
    }
    
    var id:Int
    var name:String
    var released:String
    var background_image:String
    var rating:Double
    var rating_top:Double
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.released = try container.decode(String.self, forKey: .released)
        self.background_image = try container.decode(String.self, forKey: .background_image)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.rating_top = try container.decode(Double.self, forKey: .rating_top)
        
    }
}
