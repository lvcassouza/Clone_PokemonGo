//  CoreDataPokemon.swift
//  Pokemon Go
//
//  Created by Lucas Souza on 23/09/22.

import UIKit
import CoreData

class CoreDataPokemon {
    
    //recuperar o Gerenciador de objetos
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let gerenciador = appDelegate?.persistentContainer.viewContext
        
        return gerenciador!
    }
    
    //recupera os pokemons capturados e nao capturados
    func recuperarPokemonCapturado (capturado: Bool) -> [Pokemon] {
        
        let gerenciador = self.getContext()
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        
        requisicao.predicate = NSPredicate(format: "capturado == %d", capturado)
        
        do {
            let pokemons = try gerenciador.fetch(requisicao) as [Pokemon]
            return pokemons
        } catch {}
        
        return []
    }
    
    func salvarPokemon(pokemon: Pokemon){
        
        let context = self.getContext()
        pokemon.capturado = true
        
        do {
            try context.save()
        } catch  {}
        
    }
    
    //adicionar todos os pokemons
    func adicionarPokemons() {
        
        let context = self.getContext()
        
        self.criarPokemon(nome: "Mew", nomeImagem: "mew", capturado: false)
        self.criarPokemon(nome: "Charmander", nomeImagem: "charmander", capturado: false)
        self.criarPokemon(nome: "Bellsprout", nomeImagem: "bellsprout", capturado: false)
        self.criarPokemon(nome: "Bullbasaur", nomeImagem: "bullbasaur", capturado: false)
        self.criarPokemon(nome: "Caterpie", nomeImagem: "caterpie", capturado: false)
        self.criarPokemon(nome: "Meowth", nomeImagem: "meowth", capturado: false)
        self.criarPokemon(nome: "Pikachu", nomeImagem: "pikachu", capturado: true)
        self.criarPokemon(nome: "Psyduck", nomeImagem: "psyduck", capturado: false)
        self.criarPokemon(nome: "Rattata", nomeImagem: "rattata", capturado: false)
        self.criarPokemon(nome: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.criarPokemon(nome: "Squirtle", nomeImagem: "squirtle", capturado: false)
        self.criarPokemon(nome: "Zubat", nomeImagem: "zubat", capturado: false)
        
        do {
            try context.save()
        } catch  {
            
        }
    }
    
    //criar os pokemons
    func criarPokemon(nome: String, nomeImagem: String, capturado: Bool){
        
        let gerenciador = self.getContext()
        let pokemon = Pokemon(context: gerenciador)
        
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
        
        
    }
    
    //recuperar os pokemons
    func recuperarPokemons() -> [Pokemon] {
        let context = self.getContext()
        
        do {
            let pokemons = try context.fetch( Pokemon.fetchRequest() ) as! [Pokemon]
            
            if pokemons.count == 0 {
                
                self.adicionarPokemons()
                
                return self.recuperarPokemons()
                
            }
            
            return pokemons
            
        } catch  {
            
            return []
        }
        
    }
    
}
