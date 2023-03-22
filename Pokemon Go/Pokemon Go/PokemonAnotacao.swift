//
//  PokemonAnotacao.swift
//  Pokemon Go
//
//  Created by Lucas Souza on 23/09/22.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        
        self.pokemon = pokemon
        
    }
    
}
