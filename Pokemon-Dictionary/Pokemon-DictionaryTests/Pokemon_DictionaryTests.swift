//
//  Pokemon_DictionaryTests.swift
//  Pokemon-DictionaryTests
//
//  Created by 오준솔 on 2022/10/19.
//

import XCTest
import Combine
@testable import Pokemon_Dictionary

class Pokemon_DictionaryTests: XCTestCase {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
//        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(session: session)
    private var cancellables: [AnyCancellable] = []
    
    override func setUpWithError() throws {
        //URLProtocol.registerClass(URLProtocolMock.self)
    }

    override func tearDownWithError() throws {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }

    func test_loadPokemonNames_finishedSuccessfully() throws {
        
        //Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        let resource = Resource<PokemonNamesResponse>.pokemonNames()
        var result: Result<PokemonNamesResponse, Error>?
        
        //When
        networkService.load(resource)
            .map({ names -> Result<PokemonNamesResponse, Error> in Result.success(names)})
            .catch({ error -> AnyPublisher<Result<PokemonNamesResponse, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
                    
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        guard case .success(let names) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(names.pokemonNameInfos.count > 0, true)
    }

    func test_loadPokemonLocations_finishedSuccessfully() throws {
        
        //Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        let resource = Resource<PokemonLocationsResponse>.pokemonLocations()
        var result: Result<PokemonLocationsResponse, Error>?
        
        //When
        networkService.load(resource)
            .map({ locations -> Result<PokemonLocationsResponse, Error> in Result.success(locations)})
            .catch({ error -> AnyPublisher<Result<PokemonLocationsResponse, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
                    
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        guard case .success(let locations) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(locations.pokemonLocationInfos.count > 0, true)
    }
    
    func test_loadPokemon_finishedSuccessfully() throws {
        
        //Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        let resource = Resource<Pokemon>.pokemon(id: 1)
        var result: Result<Pokemon, Error>?
        
        //When
        networkService.load(resource)
            .map({ pokemon -> Result<Pokemon, Error> in Result.success(pokemon)})
            .catch({ error -> AnyPublisher<Result<Pokemon, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
                    
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
                    
        guard case .success(let pokemon) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(pokemon.id == 1, true)
    }
    
    func test_loadFailedWithInternalError() throws {
        
        //Given
        let url = URL(string: "https://demo2575987.mockable.io/pokemon_name123")! //Wrong URL
        let resource = Resource<PokemonNamesResponse>(url: url)
        let expectation = self.expectation(description: "networkServiceExpectation")
        var result: Result<PokemonNamesResponse, Error>?
        
        //When
        networkService.load(resource)
            .map({ names -> Result<PokemonNamesResponse, Error> in Result.success(names)})
            .catch({ error -> AnyPublisher<Result<PokemonNamesResponse, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
                    
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        guard case .failure(let error) = result,
            let networkError = error as? NetworkError,
            case NetworkError.dataLoadingError(statusCode: 404, _) = networkError else {
            XCTFail()
            return
        }
    }
}
