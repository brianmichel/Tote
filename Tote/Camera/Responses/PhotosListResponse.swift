//
//  PhotosListResponse.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

struct Folder: Codable {
    var name: String
    var files: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case files = "files"
    }
}

final class PhotosListResponse: Codable {
    var folders: [Folder] = []
    
    enum CodingKeys: String, CodingKey {
        case folders = "dirs"
    }
}
