//
//  CameraAPIEndpoints.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case PUT
    case PATCH
    case POST
}

protocol CameraAPIEndpoints {
    var host: String { get }
    var version: String { get }
    
    func props() -> CameraAPIRequest
    func photos() -> CameraAPIRequest
    func specificPhoto(folder: String, file: String) -> CameraAPIRequest
    func specificPhotoInfo(folder: String, file: String) -> CameraAPIRequest
}

struct CameraV1APIEndpoints: CameraAPIEndpoints {
    let host: String = "192.168.0.1"
    let version: String = "v1"
}

struct Debug_CameraV1APIEndpoints: CameraAPIEndpoints {
    let host: String = "127.0.0.1:3000"
    let version: String = "v1"
}

struct CameraAPIRequest {
    let method: HTTPMethod = .GET
    let urlString: String
    
    func request() -> URLRequest {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method.rawValue
        
        return request
    }
}

