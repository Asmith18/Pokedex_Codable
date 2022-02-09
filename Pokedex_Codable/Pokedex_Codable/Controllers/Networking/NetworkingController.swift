//
//  NetworkingController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation
import UIKit.UIImage

class NetworkingController {
    
    private static let baseURLString = "https://pokeapi.co"
    
    static var initialURL: URL? {
        guard let baseURL = URL(string: baseURLString) else {return nil}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/api/v2/pokemon/"
        
        guard let finalURL = urlComponents?.url else {return nil}
        print(finalURL)
        return finalURL
    }
    
    static func fetchPokedex(with url: URL, completion: @escaping (Result<Pokedex, ResultError>) -> Void) {
        
        
        URLSession.shared.dataTask(with: url) { dTaskData, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let pokemonData = dTaskData else {
                completion(.failure(.noData))
                return }
            
            do {
                let pokedex = try JSONDecoder().decode(Pokedex.self, from: pokemonData)
                completion(.success(pokedex))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchPokemon(with urlString: String, completion: @escaping (Result<Pokemon, ResultError>) -> Void) {
        guard let pokemonURL = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return}
        
        URLSession.shared.dataTask(with: pokemonURL) { dTaskData, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let pokemonData = dTaskData else {
                completion(.failure(.noData))
                return }
            
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: pokemonData)
                completion(.success(pokemon))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
//MARK: - TODO PLZZZZZ and thXXXXXXXXx
    static func fetchImage(for pokemon: String, completetion: @escaping (Result<UIImage, ResultError>) -> Void) {
        guard let imageURL = URL(string: pokemon) else {return}
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                completetion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completetion(.failure(.noData))
                return
            }
            guard let pokemonImage = UIImage(data: data) else {
                completetion(.failure(.unableToDecode))
                return
            }
            completetion(.success(pokemonImage))
        }.resume()
    }
}// end
