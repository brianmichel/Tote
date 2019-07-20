//
//  String+PhotoType.swift
//  Tote
//
//  Created by Brian Michel on 7/4/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

enum PhotoFileExtension: String {
    case dng
    case jpg
    case other
}

extension String {
    func photoFileExtension() -> PhotoFileExtension {
        if lowercased().hasSuffix(".dng") { return .dng }
        if lowercased().hasSuffix(".jpg") { return .jpg }

        return .other
    }

    func withRawExtension() -> String {
        return "\(self).DNG"
    }

    func withJpgExtension() -> String {
        return "\(self).JPG"
    }
}
