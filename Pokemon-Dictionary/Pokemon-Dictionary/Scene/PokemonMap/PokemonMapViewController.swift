//
//  PokemonMapViewController.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/23.
//

import Foundation
import MapKit

//without storyboard
class PokemonMapViewController: UIViewController {
    
    var pokemonLocations: [PokemonLocationInfo] = []
    
    convenience init(locations: [PokemonLocationInfo]) {
        self.init()
        
        self.pokemonLocations = locations
    }
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        initializeMap()
    }
    
    func makeConstraints() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor
                .constraint(equalTo: view.topAnchor),
            mapView.leftAnchor
                .constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor
                .constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor
                .constraint(equalTo: view.bottomAnchor),
        ])
        
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor
                .constraint(equalToConstant: 60.0),
            backButton.heightAnchor
                .constraint(equalToConstant: 60.0),
            backButton.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leftAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
    func initializeMap() {
        guard let firstLocation = pokemonLocations.first else { return }
        let initialLocation = CLLocation(latitude: firstLocation.lat, longitude: firstLocation.lng)
        let coordinateRegion = MKCoordinateRegion(
              center: initialLocation.coordinate,
              latitudinalMeters: 100000,
              longitudinalMeters: 100000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        pokemonLocations.forEach { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func backButtonAction(sender: UIButton!) {
        self.dismiss(animated: true)
    }
}
