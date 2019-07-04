//
//  PhotosListResponse.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

final class Folder: Codable {
    var name: String
    var files: [String]

    lazy var reversedFiles: [String] = {
        files.reversed()
    }()

    enum CodingKeys: String, CodingKey {
        case name
        case files
    }
}

final class PhotosListResponse: Codable {
    var folders: [Folder] = []

    enum CodingKeys: String, CodingKey {
        case folders = "dirs"
    }
}
