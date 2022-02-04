//
//  Network Controller.swift
//  Pokedex
//
//  Created by Arian Mohajer on 2/3/22.
//

import Foundation
import UIKit

class NetworkController {
    private static var baseURL = "https://pokeapi.co"
    var pokemon: Pokemon?
    
    static func fetchPokemon(from searchTerm: String, completion: @escaping (Pokemon?) -> Void) {
        guard let url = URL(string: baseURL) else { completion(nil); return}
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/api/v2/pokemon/" + searchTerm.lowercased()
        
        guard let finalURL = urlComponents?.url else {
            completion(nil)
            print("Unable to get final URL from: \(urlComponents?.url)")
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error fetching data from \(finalURL).", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error with data: \(data)")
                completion(nil)
                return
            }
            
            do {
                guard let topLevelDictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any] else {
                    print("Error serializing data from \(data)")
                    completion(nil)
                    return
                }
                
                guard let pokemonToReturn = Pokemon(dictionary: topLevelDictionary) else {
                    print("Unable to create pokemon from \(topLevelDictionary)")
                    completion(nil)
                    return
                }
                print(pokemonToReturn.id)
                print(pokemonToReturn.moveList)
                completion(pokemonToReturn)
                
            } catch {
                print(data)
                print("Error with do/try/catch", error)
            }
        }.resume()
    }
    
    static func fetchPokemonImage(pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
        guard let pokemonImageURL = URL(string: pokemon.imageString) else {
            print("Error building pokemon's image URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: pokemonImageURL) {data, _, error in
            
            if let error = error {
                print("Error retrieving image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error with pokemon image data: \(data)")
                completion(nil)
                return
            }
            
            let pokemonImageToReturn = UIImage(data: data)
            
            completion(pokemonImageToReturn)
            
        }.resume()
    }
}
