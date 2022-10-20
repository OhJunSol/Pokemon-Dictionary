//
//  NetworkServiceType.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {

    func load<T>(_ resource: Resource<T>, policy: URLRequest.CachePolicy) -> AnyPublisher<T, Error>
}

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
    case genericError(error: Error)
}
