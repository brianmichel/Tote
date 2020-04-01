//
//  PhotoGroup.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
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
