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

    static func type(for url: MediaURL) -> MediaVariantType {
        switch url.type {
        case .dng:
            return .raw
        case .jpg:
            return .jpeg
        case .other:
            return .video
        }
    }
}

final class MediaGroup {
    private var files: [MediaVariantType: (url: MediaURL, metadata: MediaInfo?)]
    let groupName: String
    let folderName: String

    init(files: [MediaURL], groupName: String, folder: String) {
        folderName = folder

        var groupedFiles = [MediaVariantType: (url: MediaURL, metadata: MediaInfo?)]()

        files.forEach { url in
            let type = MediaVariantType.type(for: url)
            groupedFiles[type] = (url, nil)
        }

        self.groupName = groupName
        self.files = groupedFiles

        Log.debug("Creating group '\(groupName)' with \(files.count) file(s)")
    }

    func update(metadata: MediaInfo, for url: MediaURL) {
        let type = MediaVariantType.type(for: url)
        files[type] = (url, metadata)
    }

    func variants() -> MediaVariantType {
        return MediaVariantType(Array(files.keys))
    }

    func file(for variant: MediaVariantType) -> MediaURL? {
        guard let (url, _) = files[variant] else {
            return nil
        }

        return url
    }

    func metadata(for file: MediaURL) -> MediaInfo? {
        let variant = MediaVariantType.type(for: file)

        guard
            let (_, meta) = files[variant],
            let metadata = meta
        else {
            return nil
        }

        return metadata
    }

    func thumbnailURL() -> URL? {
        return preferredFile()?.resized(to: .view)
    }

    func preferredFile() -> MediaURL? {
        if let (url, _) = files[.jpeg] {
            return url
        } else if let (url, _) = files[.raw] {
            return url
        }

        return nil
    }
}
