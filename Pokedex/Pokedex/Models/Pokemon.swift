//
//  Pokemon.swift
//  Pokedex
//
//  Created by Arian Mohajer on 2/3/22.
//

import Foundation

class Pokemon {
    var id: Int
    var name: String
    var imageDictionary: [String : Any]
    var imageString: String
    var movesOuterContainer: [[String: Any]]
    var moveList: [String]
    
    
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? Int,
              let name = dictionary["name"] as? String,
              let imageDictionary = dictionary["sprites"] as? [String:Any],
              let imageString = imageDictionary["front_shiny"] as? String,
              let movesOuterContainer = dictionary["moves"] as? [[String:Any]] else {return nil}
        
        self.id = id
        self.name = name
        self.imageDictionary = imageDictionary
        self.imageString = imageString
        self.movesOuterContainer = movesOuterContainer
        
        var moveList = [String]()
        
        for dictionary in movesOuterContainer {
            if let moveDictionary = dictionary["move"] as? [String:Any] {
                if let moveToAdd = moveDictionary["name"] as? String {
                    moveList.append(moveToAdd)
                }
            }
        }
        
        self.moveList = moveList
    }
}
