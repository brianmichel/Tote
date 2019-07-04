//
//  PhotoInfoResponse.swift
//  Tote
//
//  Created by Brian Michel on 7/4/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import CoreMedia
import Foundation

struct CaptureInformation: Codable {
    let aperture: String
    let shutterSpeed: String
    let iso: String

    enum CodingKeys: String, CodingKey {
        case aperture = "av"
        case shutterSpeed = "tv"
        case iso = "sv"
    }
}

final class PhotoInfoResponse: Codable {
    let cameraModel: String
    let name: String
    let size: Int
    let date: Date

    let captureInformation: CaptureInformation
}
