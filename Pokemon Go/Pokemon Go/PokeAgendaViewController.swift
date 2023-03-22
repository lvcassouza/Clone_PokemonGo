//
//  PokeAgendaViewController.swift
//  Pokemon Go
//
//  Created by Lucas Souza on 23/09/22.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var pokemonsCapturados: [Pokemon] = []
    var pokemonsNaoCapturados: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pokemonsCapturados = CoreDataPokemon().recuperarPokemonCapturado(capturado: true as Bool)
        self.pokemonsNaoCapturados = CoreDataPokemon().recuperarPokemonCapturado(capturado: false as Bool)
        
        
        print(String(self.pokemonsNaoCapturados.count))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else{
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.pokemonsCapturados.count
        }else{
            return self.pokemonsNaoCapturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        if indexPath.section == 0 {
            pokemon = self.pokemonsCapturados[ indexPath.row ]
        }else {
            pokemon = self.pokemonsNaoCapturados [ indexPath.row ]
            
        }
        
        let celula = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "celula")
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage( named: pokemon.nomeImagem! )
        
        return celula
    }
    
    @IBAction func voltarMapa(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
