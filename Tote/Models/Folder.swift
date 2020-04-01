//
//  Folder.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

struct FileURL: Encodable {
    var base: URL

    func resized(to size: PhotoSize) -> URL? {
        var components = URLComponents(string: base.absoluteString)
        components?.queryItems = [URLQueryItem(name: "size", value: size.rawValue)]

        return components?.url
    }
}

final class Folder: Codable {
    var name: String
    var files: [FileURL]

    lazy var reversedFiles: [FileURL] = {
        files.reversed()
    }()

    enum CodingKeys: String, CodingKey {
        case name
        case files
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: CodingKeys.name)
        let files = try container.decode([String].self, forKey: CodingKeys.files)

        guard let context = decoder.userInfo[CodingUserInfoKey.decodingContext] as? DecodingContext else {
            fatalError("Unable to locate DecodingContext for further processing")
        }

        let fileURLs = files.map { (file) -> FileURL in
            FileURL(base: context.builder.urlForSpecificPhoto(folder: name, file: file))
        }

        self.name = name
        self.files = fileURLs
    }
}
