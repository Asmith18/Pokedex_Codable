//
//  PokeDexTableViewController.swift
//  Pokedex_Codable
//
//  Created by adam smith on 2/8/22.
//

import UIKit

class PokeDexTableViewController: UITableViewController {
    
//    var pokemon: [Pokemon] = []
    
   var pokedex: Pokedex?
//
   var pokedexResults: [PokedexResults] = [] // SOT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingController.fetchPokedex(with: NetworkingController.initialURL!) { result in
            switch result {
            case .success(let pokedex):
                self.pokedexResults = pokedex.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("there was an error, \(error.errorDescription!)")
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokedexResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokedexCell", for: indexPath) as? PokedexTableViewCell else { return UITableViewCell() }
        
        let pokemon = pokedexResults[indexPath.row]
        cell.updateViews(pokemonURLString: pokemon.url)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastPokemonIndex = pokedexResults.count - 1
        
        guard let pokemonData = pokedex, let nextURL = URL(string: pokemonData.next) else { return }
        
        NetworkingController.fetchPokedex(with: nextURL) { result in
            switch result {
            case .success(let nextPokedex):
                self.pokedexResults.append(contentsOf: nextPokedex.results)
            case .failure(let error):
                print("there was an error", (error.errorDescription))
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPokemonVC" {
            if let destination = segue.destination as? PokemonViewController {
                guard let index = tableView.indexPathForSelectedRow else { return }
                let pokemonToSend = pokedexResults[index.row]
                NetworkingController.fetchPokemon(with: pokemonToSend.url) { result in
                    switch result {
                    case .success(let pokemon):
                        destination.pokemon = pokemon
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("not working bitch, \(error.errorDescription!)")
                    }
                }
            }
        }
    }
}
