//
//  CameraAPIEndpoints+Extensions.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

extension CameraAPIEndpoints {
    func props() -> CameraAPIRequest {
        return CameraAPIRequest(urlString: "http://\(host)/\(version)/props")
    }
    func photos() -> CameraAPIRequest {
        return CameraAPIRequest(urlString: "http://\(host)/\(version)/photos")
    }
    func specificPhoto(folder: String, file: String) -> CameraAPIRequest {
        return CameraAPIRequest(urlString: "http://\(host)/\(version)/\(folder)/\(file)")
    }
    
    func specificPhotoInfo(folder: String, file: String) -> CameraAPIRequest {
        return CameraAPIRequest(urlString: "http://\(host)/\(version)/\(folder)/\(file)/info")
    }
}
