//
//  ApplicationViewController.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

class ApplicationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // Since we're much more constrained on iPhone, limit the orientation to just portait.
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [.all]
        } else {
            return [.portrait]
        }
    }
}
