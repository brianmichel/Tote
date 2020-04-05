//
//  SettingsViewController.swift
//  Tote
//
//  Created by Brian Michel on 4/5/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import SwiftUI

final class SettingsViewController: UIHostingController<SettingsView> {
    private var storage = Set<AnyCancellable>()
    init() {
        super.init(rootView: SettingsView())

        rootView.dismiss = { [weak self] in self?.dismiss(animated: true, completion: nil) }
    }

    @objc dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
