//
//  CameraAPI.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

enum CameraAPIError: Error {
    case noData
    case error(Int)
}

final class CameraAPI {
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let endpoints: CameraAPIEndpoints

    init(endpoints: CameraAPIEndpoints = CameraV1APIEndpoints()) {
        self.endpoints = endpoints
    }

    // MARK: - Public API

    func photos(completion: @escaping ((Result<PhotosListResponse>) -> Void)) -> URLSessionTask {
        return load(request: endpoints.photos(), completion: completion)
    }

    // MARK: - Private

    private func load<T: Codable>(request: CameraAPIRequest,
                                  completion: @escaping (Result<T>) -> Void) -> URLSessionTask {
        let urlRequest = request.request()

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(CameraAPIError.noData))
                return
            }

            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()

        return task
    }
}
