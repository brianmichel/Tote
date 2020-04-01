//
//  API.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import Foundation

protocol API {
    func folders() -> AnyPublisher<FolderList, Error>
    func specificPhotoURL(folder: String, file: String) -> AnyPublisher<URL, Never>
    func specificPhotoInfo(folder: String, file: String) -> AnyPublisher<MediaInfo, Error>
}

struct NetworkAPI: API {
    let host: String
    let version: String

    private let builder: APIURLBuilder
    private let agent = Agent()
    private let decoder: JSONDecoder

    init(host: String, version: String) {
        self.host = host
        self.version = version
        builder = APIURLBuilder(host: host, version: version)
        decoder = JSONDecoder(context: DecodingContext(host: host, version: version, builder: builder))
    }

    func folders() -> AnyPublisher<FolderList, Error> {
        let url = builder.urlForPhotos()

        return agent
            .run(url, decoder)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func specificPhotoURL(folder: String, file: String) -> AnyPublisher<URL, Never> {
        return Just(builder.urlForSpecificPhoto(folder: folder,
                                                file: file))
            .eraseToAnyPublisher()
    }

    func specificPhotoInfo(folder: String, file: String) -> AnyPublisher<MediaInfo, Error> {
        let url = builder.urlForSpecificPhotoInfo(folder: folder, file: file)

        return agent
            .run(url, decoder)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

extension NetworkAPI {
    static let standard = NetworkAPI(host: "192.168.0.1",
                                     version: "v1")

    static let local = NetworkAPI(host: "127.0.0.1:3000",
                                  version: "v1")
}
