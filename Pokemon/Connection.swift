//
//  Connection.swift
//  Pokemon
//
//  Created by Alexandru Bogdan Potcoava on 5/3/22.
//

import Foundation
import UIKit

class Connection{
    
    let URL_BASE: String = "https://pokeapi.co/api/v2/"
    
    func getPokemon(withId id: Int, completion: @escaping (_ pokemon: Pokemon?) -> Void){
        guard let url = URL(string: URL_BASE + "pokemon/\(id)") else {
            completion(nil)
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = urlSession.dataTask(with: url){
            data, response, error in
            if error == nil {
                let pokemon = Pokemon(withJsonData: data)
                completion(pokemon)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    func getSprite(with urlString: String, completion: @escaping (_ sprite: UIImage?) -> Void){
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = urlSession.dataTask(with: url){
            data, response, error in
            
            if(response as! HTTPURLResponse).statusCode == 200{
                if error == nil , let data = data{
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}



