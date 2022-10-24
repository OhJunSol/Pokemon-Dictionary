//
//  NetworkService.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceType {
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
    
    func load(url: URL, policy: URLRequest.CachePolicy = .returnCacheDataElseLoad) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.cachePolicy = policy
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                guard 200..<300 ~= response.statusCode else {
                    throw NetworkError.dataLoadingError(statusCode: response.statusCode, data: data)
                }
                
                guard data.count > 0 else { throw NetworkError.zeroByteResource }
                return data
            }
            .eraseToAnyPublisher()
    }

    func load<T>(_ resource: Resource<T>, policy: URLRequest.CachePolicy = .returnCacheDataElseLoad) -> AnyPublisher<T, Error> {
        guard var request = resource.request else {
            return .fail(NetworkError.invalidRequest)
        }
        request.cachePolicy = policy
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }

                guard 200..<300 ~= response.statusCode else {
                    throw NetworkError.dataLoadingError(statusCode: response.statusCode, data: data)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                (error as? DecodingError) != nil
                    ? NetworkError.jsonDecodingError(error: error)
                    : error
            }
        .eraseToAnyPublisher()
    }

}
