//
//  APIURLBuilder.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

enum PhotoSize: String {
    case thumb
    case view
    case full
}

struct APIURLBuilder {
    let host: String
    let version: String

    func urlForPhotos() -> URL {
        guard let url = URL(string: "http://\(host)/\(version)/photos") else {
            Log.error("Unable to assemble a known, good URL")
            fatalError("Unable to assemble a known, good URL")
        }

        return url
    }

    func urlForProps() -> URL {
        guard let url = URL(string: "http://\(host)/\(version)/props") else {
            Log.error("Unable to assemble a known, good URL")
            fatalError("Unable to assemble a knonw, good URL")
        }

        return url
    }

    func urlForSpecificPhoto(folder: String, file: String) -> URL {
        guard let url = URL(string: "http://\(host)/\(version)/photos/\(folder)/\(file)") else {
            Log.error("Unable to assemble a known, good URL")
            fatalError("Unable to assemble a known, good URL")
        }

        return url
    }

    func urlForSpecificPhotoInfo(folder: String, file: String) -> URL {
        guard let url = URL(string: "http://\(host)/\(version)/photos/\(folder)/\(file)/info") else {
            Log.error("Unable to assemble a known, good URL")
            fatalError("Unable to assemble a known, good URL")
        }

        return url
    }
}
