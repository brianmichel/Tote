//
//  MediaURLGrouper.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

struct MediaURLGrouper {
    let urls: [MediaURL]
    let folder: String

    func groups() -> [MediaGroup] {
        let grouped = Dictionary(grouping: urls) { element in
            element.fileName.withoutExtension()
        }

        let groups = grouped.map { (fileName, mediaURLs) -> MediaGroup in
            MediaGroup(files: mediaURLs, groupName: fileName, folder: folder)
        }

        return groups
    }
}
