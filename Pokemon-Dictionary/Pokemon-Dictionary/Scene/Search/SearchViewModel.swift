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
    
    var items: [(id:Int, name:String)] = []
    
    //Network
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(session: session)
    private var cancellables: [AnyCancellable] = []
    
    func search(query: String) {
        searchedItems = items.filter{ $0.name.localizedCaseInsensitiveContains(query) }
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
                self?.items = []
                response.pokemonNameInfos.forEach { info in
                    info.names.forEach { name in
                        self?.items.append((id: info.id, name: name))
                    }
                }
            }.store(in: &cancellables)

    }
}
