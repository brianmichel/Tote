//
//  Agent.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import Foundation

struct Agent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    private let session = URLSession(configuration: .background(withIdentifier: "me.foureyes.tote.networking"))

    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func run<T: Decodable>(_ URL: URL, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        let request = URLRequest(url: URL)

        return run(request, decoder)
    }
}
