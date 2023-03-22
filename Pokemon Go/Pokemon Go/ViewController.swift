//
//  ViewController.swift
//  Pokemon Go
//
//  Created by Lucas Souza on 22/09/22.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    let gerenciadorLocalizacao = CLLocationManager ()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        //recuperar pokemons
        
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarPokemons()
        
        //exibir pokemons
    
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
            
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                
                let totalPokemons = self.pokemons.count
                
                let indicePokemonAleatorio = arc4random_uniform(UInt32(totalPokemons))
                
                let pokemonMostrado = self.pokemons [ Int( indicePokemonAleatorio ) ]
                
                let longRandom = (Double (arc4random_uniform(500)) - 250) / (Double (arc4random_uniform(100000)))
                let latRandom = (Double (arc4random_uniform(500)) - 250) / (Double (arc4random_uniform(100000)))
                
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemonMostrado )
                
                anotacao.coordinate.latitude += latRandom
                anotacao.coordinate.longitude += longRandom
            
                self.mapa.addAnnotation(anotacao)
        }
            
    }
}
    
    //=================== fim view did load =======================//
    
    //trocando o desenho da anotacao/usuario pelo desenho do personagem/pokemons
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation{
            
            anotacaoView.image = UIImage(named: "player")
            
        }else{
            let anotNomePokemon = (annotation as! PokemonAnotacao).pokemon
            
            anotacaoView.image = UIImage(named: anotNomePokemon.nomeImagem!)
            
        }
        
        return anotacaoView
        
    }
    
    
   //capturando pokemons
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
            let anotacao = view.annotation
            mapView.deselectAnnotation(anotacao, animated: true)
            let pokemon = (view.annotation as! PokemonAnotacao).pokemon
            
            
            if anotacao is MKUserLocation{
                return
            }
            
        if let coordenadasAnotacao = anotacao?.coordinate{
            let regiao = MKCoordinateRegion.init(center: coordenadasAnotacao, latitudinalMeters: 750, longitudinalMeters: 750)
            mapa.setRegion(regiao, animated: true)
            
            var lat: Double = (gerenciadorLocalizacao.location?.coordinate.latitude)! as Double
            var log: Double = (gerenciadorLocalizacao.location?.coordinate.longitude)! as Double
            var a: Double = (coordenadasAnotacao.latitude + coordenadasAnotacao.longitude)
            var b: Double = ((lat+log))
            var c: Double = (b/a)
            
            if c <= 1 {
                
                self.coreDataPokemon.salvarPokemon(pokemon: pokemon)
                
                self.mapa.removeAnnotation(anotacao!)
                
                let alertController = UIAlertController(title: "CAPTURADO", message: "Voce capturou o: \(pokemon.nome!).", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(ok)
                self.present(alertController, animated: true)}
            
            else {
                self.coreDataPokemon.salvarPokemon(pokemon: pokemon)
                
                self.mapa.removeAnnotation(anotacao!)
                
                let alertController = UIAlertController(title: "Não foi hoje", message: "O  \(pokemon.nome!) foi mais rápido e está muito longe para ser capturado.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(ok)
                self.present(alertController, animated: true)
        }
            }
                    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 4 {
            
            self.centralizar()
            contador += 1
            
        }else{
            
            gerenciadorLocalizacao.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            //alerta
            let alertController = UIAlertController(title: "Permissão de localização", message: "Você precisa liberar sua localização para jogar.", preferredStyle: .alert)
            
            let acaoConfiguracao = UIAlertAction(title: "Abrir configurações", style: .default, handler:{ (alertaConfiguracao) in
                if let configuracoes = NSURL(string: UIApplication.openNotificationSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracao)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func centralizar(){
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate{
            
            let regiao = MKCoordinateRegion.init(center: coordenadas, latitudinalMeters: 750, longitudinalMeters: 750)
            mapa.setRegion(regiao, animated: true)
        }}
    
    @IBAction func centralizarJogador(_ sender: Any) {
        
        self.centralizar()
        
        }
    
    @IBAction func abrirPokedex(_ sender: Any) {
    }
    
}


