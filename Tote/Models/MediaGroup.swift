//
//  MediaGroup.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

struct MediaVariantType: OptionSet, Hashable {
    let rawValue: Int

    static let raw = MediaVariantType(rawValue: 1 << 0)
    static let jpeg = MediaVariantType(rawValue: 1 << 1)
    static let video = MediaVariantType(rawValue: 1 << 2)
    static let rawPlusJpeg: MediaVariantType = [.raw, .jpeg]
}

struct MediaGroup {
    let files: [MediaVariantType: MediaURL]
    let folder: String

    init(files: [MediaURL], folder: String) {
        self.folder = folder

        var groupedFiles = [MediaVariantType: MediaURL]()

        files.forEach { url in
            switch url.type {
            case .dng:
                groupedFiles[.raw] = url
            case .jpg:
                groupedFiles[.jpeg] = url
            case .other:
                groupedFiles[.video] = url
            }
        }

        self.files = groupedFiles
    }

    func variants() -> MediaVariantType {
        return MediaVariantType(Array(files.keys))
    }
}
