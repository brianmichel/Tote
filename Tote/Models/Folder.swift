//
//  Folder.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

struct MediaURL: Encodable {
    var base: URL
    var fileName: String
    var folderName: String
    var type: PhotoFileExtension {
        return base.absoluteString.photoFileExtension()
    }

    func resized(to size: PhotoSize) -> URL? {
        var components = URLComponents(string: base.absoluteString)
        components?.queryItems = [URLQueryItem(name: "size", value: size.rawValue)]

        return components?.url
    }
}

final class Folder: Codable {
    var name: String
    var files: [MediaURL]
    var groups: [MediaGroup]

    lazy var reversedGroups: [MediaGroup] = {
        groups.reversed()
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

        let fileURLs = files.map { (file) -> MediaURL in
            MediaURL(base: context.builder.urlForSpecificPhoto(folder: name, file: file), fileName: file, folderName: name)
        }

        let mediaGrouper = MediaURLGrouper(urls: fileURLs, folder: name)
        let groups = mediaGrouper.groups()

        self.name = name
        self.groups = groups
        self.files = fileURLs
    }
}
