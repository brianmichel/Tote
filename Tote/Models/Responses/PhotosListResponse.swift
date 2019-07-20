//
//  PhotosListResponse.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

enum PhotoGroupType: String {
    case raw
    case jpg
    case rawPlusJpg
}

struct PhotoGroup {
    let baseName: String
    let folder: String
    let type: PhotoGroupType
}

final class Folder: Codable {
    var name: String
    var files: [String]

    lazy var reversedFiles: [String] = {
        files.reversed()
    }()

    lazy var photoGroups: [PhotoGroup] = {
        let countedSet = NSCountedSet(capacity: files.count)
        for file in files {
            let withoutSuffix = file.dropLast(4)
            countedSet.add(withoutSuffix)
        }

        let groups = countedSet.sortedArray(using: [NSSortDescriptor(key: "hash", ascending: false)]).map { group -> PhotoGroup in
            let count = countedSet.count(for: group)
            let endGroup = group as? String ?? "okay"
            var type = PhotoGroupType.rawPlusJpg

            if count == 1 {
                type = .raw
            }

            return PhotoGroup(baseName: endGroup, folder: name, type: type)
        }

        return groups
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
