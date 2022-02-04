//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Karl Pfister on 2/3/22.
//

import UIKit

class PokemonViewController: UIViewController {

    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonMovesTableView: UITableView!
    
    var pokemon: Pokemon? {
        didSet {
            pokemonMovesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonSearchBar.delegate = self
        pokemonMovesTableView.delegate = self
        pokemonMovesTableView.dataSource = self
    }
}// End
extension PokemonViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text else { return }
        
        NetworkController.fetchPokemon(from: searchTerm) { pokemon in
            guard let pokemon = pokemon else { return }
            
            
            DispatchQueue.main.async {
                self.pokemonNameLabel.text = pokemon.name
                self.pokemonIDLabel.text = "\(pokemon.id)"
                self.pokemon = pokemon
                self.pokemonMovesTableView.reloadData()
            }
            
            NetworkController.fetchPokemonImage(pokemon: pokemon) { pokemonImage in
                guard let pokemonImage = pokemonImage else { return }
                
                DispatchQueue.main.async {
                    self.pokemonSpriteImageView.image = pokemonImage
                }
            }
        }
    }
}

extension PokemonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Moves"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pokemon = pokemon else { return 0 }
        return pokemon.moveList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath)
        cell.textLabel?.text = pokemon?.moveList[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
}
