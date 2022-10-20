//
//  SearchViewModel.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/20.
//

import Foundation
import Combine

class SearchViewModel {
    
    //Output
    @Published var searchedItems: [(id:Int, name:String)] = []
    
    //Error
    @Published var error: Error?
    
    private var names: [(id:Int, name:String)] = []
    
    private lazy var networkService = NetworkService()
    private var cancellables: [AnyCancellable] = []
    
    func search(query: String) {
        searchedItems = names.filter{ $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    func fetchData() {
        let resource = Resource<PokemonNamesResponse>.pokemonNames()
        
        networkService.load(resource)
            .sink { [weak self] completion in
                if case .failure(let err) = completion {
                    print("Error occured \(err)")
                    self?.error = err
                }
            } receiveValue: { [weak self] response in
                self?.names = []
                response.pokemonNameInfos.forEach { info in
                    info.names.forEach { name in
                        self?.names.append((id: info.id, name: name))
                    }
                }
            }.store(in: &cancellables)

    }
}
