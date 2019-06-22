//
//  ApplicationCoordinator.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

final class ApplicationCoordinator {
    private let window: UIWindow
    private let rootViewController = RootViewController()
    private let client = CameraAPI(endpoints: Debug_CameraV1APIEndpoints())
    
    init(window: UIWindow = UIWindow()) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
         let _ = client.photos { (result) in
            switch result {
            case .success(let response):
                print("Got a response! \(response)")
            case .failure(let error):
                print("Got an error: \(error)")
            }
        }
        
    }
}
