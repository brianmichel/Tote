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
    let groupName: String
    let folder: String

    init(files: [MediaURL], groupName: String, folder: String) {
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

        self.groupName = groupName
        self.files = groupedFiles

        Log.debug("Creating group '\(groupName)' with \(files.count) file(s)")
    }

    func variants() -> MediaVariantType {
        return MediaVariantType(Array(files.keys))
    }

    func file(for variant: MediaVariantType) -> MediaURL? {
        guard let url = files[variant] else {
            return nil
        }

        return url
    }

    func thumbnailURL() -> URL? {
        return preferredFile()?.resized(to: .view)
    }

    func preferredFile() -> MediaURL? {
        if let url = files[.jpeg] {
            return url
        } else if let url = files[.raw] {
            return url
        }

        return nil
    }
}
