//
//  PokedexTableViewCell.swift
//  Pokedex_Codable
//
//  Created by adam smith on 2/8/22.
//

import UIKit

class PokedexTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameTextLabel: UILabel!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    
    func updateViews(pokemonURLString: String) {
        NetworkingController.fetchPokemon(with: pokemonURLString) { result in
            switch result {
            case .success(let pokemon):
                self.fetchImage(with: pokemon)
                DispatchQueue.main.async {
                    self.pokemonNameTextLabel.text = pokemon.name
                    self.pokemonIDLabel.text = "\(pokemon.id)"
                }
            case .failure(let error):
                print("oh no oh no oh no!", error.errorDescription)
                
            }
        }
    }
    
    func fetchImage(with pokemon: Pokemon) {
        NetworkingController.fetchImage(for: pokemon.sprites.frontShiny) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.pokemonImageView.image = image
                }
            case .failure(let error):
                print("no not wok!", error.errorDescription)
            }
        }
    }
}
