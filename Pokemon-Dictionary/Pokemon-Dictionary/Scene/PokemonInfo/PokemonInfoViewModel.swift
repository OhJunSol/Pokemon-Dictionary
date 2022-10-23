//
//  PokemonInfoViewModel.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/22.
//

import Foundation
import Combine
import UIKit

class PokemonInfoViewModel {
    //Output
    let id: Int
    let names: [String]
    @Published var image: UIImage?
    @Published var weight: Int?
    @Published var height: Int?
    @Published var locations: [PokemonLocationInfo] = []
    
    //Error
    @Published var error: Error?
    
    private lazy var networkService = NetworkService()
    private var cancellables: [AnyCancellable] = []
    
    init(id: Int, names: [String]) {
        self.id = id
        self.names = names
    }
    
    func fetchData() {
        getPokemonInfo()
        getPokemonLocation()
    }
    
    func getPokemonInfo() {
        let resource = Resource<Pokemon>.pokemon(id: self.id)
        
        networkService.load(resource)
            .sink { [weak self] completion in
                if case .failure(let err) = completion {
                    print("Error occured \(err)")
                    self?.error = err
                }
            } receiveValue: { [weak self] response in
                self?.weight = response.weight
                self?.height = response.height
                if let sprites = response.sprites {
                    self?.downloadImage(sprites: sprites)
                }
            }.store(in: &cancellables)
    }
    
    func downloadImage(sprites: Sprites) {
        guard let urlString = sprites.frontDefault ?? sprites.frontShiny ?? sprites.frontFemale,
              let url = URL(string: urlString)
        else { return }
        
        networkService.load(url: url)
            .receive(on: DispatchQueue.main)
            .tryMap({ data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "dataToImageFailed", code: -1)
                }
                return image
            })
            .replaceError(with: UIImage(systemName: "xmark.diamond"))
            .sink(receiveValue: { [weak self] image in
                self?.image = image
            }).store(in: &cancellables)
    }
    
    func getPokemonLocation() {
        let resource = Resource<PokemonLocationsResponse>.pokemonLocations()
        
        networkService.load(resource)
            .sink { [weak self] completion in
                if case .failure(let err) = completion {
                    print("Error occured \(err)")
                    self?.error = err
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.locations = response.pokemonLocationInfos.filter{ $0.id == self.id }
            }.store(in: &cancellables)
    }
}
