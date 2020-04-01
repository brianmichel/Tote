//
//  FolderList.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

final class FolderList: Codable {
    var folders: [Folder] = []

    enum CodingKeys: String, CodingKey {
        case folders = "dirs"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folders = try container.decode([Folder].self, forKey: CodingKeys.folders)
    }
}
