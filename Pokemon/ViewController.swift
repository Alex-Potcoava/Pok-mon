//
//  ViewController.swift
//  Pokemon
//
//  Created by Alexandru Bogdan Potcoava on 5/3/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCellDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    
    var progressUpdate: Float = 0
    var pokemonList: Array<Pokemon> = []
    
    let ID_POKEMON_MIN: Int = 1
    let ID_POKEMON_MAX: Int = 50
    var pokemonsDownLoad: Int = 0
    var CompleteDownload: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        loadPokemon()
    }
    
    func loadPokemon(){
        startStop()
        for id in 1 ... self.ID_POKEMON_MAX{
            Connection().getPokemon(withId: id){
                pokemon in
                
                if let pokemon = pokemon {
                    self.pokemonList.append(pokemon)
                    self.pokemonsDownLoad += 1
                    //print("for \(self.pokemonList[id].name)")

                } else {
                    self.pokemonsDownLoad += 1
                    print("fallo \(id)")

                }
                self.progressUpdateOnlyForGlobalThread(Float(id))
            }
        }
        waitForAllDownloads()
    }
    
    func startStop(_ stop: Bool = false){
        if !stop{
            percentLabel.text = "0"
            progressBar.progress = 0
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            nameLabel.text = "Cargando Pokemons ..."
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            table.isHidden = false
            nameLabel.text = "Pokemons cargados!"
            percentLabel.text = "\(pokemonList.count)"
        }
    }
    
    func waitForAllDownloads(){
        DispatchQueue.global().async {
            repeat{
                if self.pokemonsDownLoad >= self.ID_POKEMON_MAX && !self.CompleteDownload{
                    self.refreshListPokemonsOnlyForGlobalThread(pokemonsList: self.pokemonList)
                    self.CompleteDownload = true
                }
                sleep(1)
            } while !self.CompleteDownload
        }
    }
    
    func progressUpdateOnlyForGlobalThread(_ n: Float) {
            //  Se calcula el porcentaje con el número del usuario
            if progressUpdate < 100.0 {
                progressUpdate = (Float(n) * 100.0) / Float(ID_POKEMON_MAX) }
            
            //  Se actualizan marcadores de progreso
            DispatchQueue.main.async {
                self.progressBar.progress = self.progressUpdate / 100
                self.nameLabel.text = "\( Int(self.progressUpdate))%"
                
            }
        }
    
    func refreshListPokemonsOnlyForGlobalThread(pokemonsList: Array<Pokemon>) {
        
        self.pokemonList.sort { (uno: Pokemon, dos: Pokemon) in
            return uno.id! < dos.id!
            
        }
        
        //Se abre un hilo en main para realizar el reload
        DispatchQueue.main.async {
            self.table.reloadData()
            self.startStop(true)
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
            
        }
        
        func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pokemonList.count
            
        }
        
        func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //Se carga la celda personalizada
            let cell: MyCellTableViewCell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            as! MyCellTableViewCell
            
            cell.delegate = self
            
            let pokemon = pokemonList[indexPath.row]
            
            //En caso de no tener información, aparecerá el texto predefinido de la celda
            if let id: Int = pokemon.id {
                if let name: String = pokemon.name {
                    cell.pokemonName.text = ("\(name)")
                    
                }
            }
            
            //En caso de no tener imagen, aparecerá la imagen predeficinda de la celda
            if let url = URL(string: pokemon.sprites?.front_default ?? "") {
                if let data = try? Data(contentsOf: url) {
                    cell.pokemonImage.image = UIImage(data: data)
                    
                }
            }
            print("Pokemons \(pokemonList.count)")
            return cell
            
        }
        
        //Sin uso
        //delegate?.callPressed(name: .text ?? "") Para usar este método
        func callPressed(name: String) {
            print("Llamando a \(name)")
        }
    
}

