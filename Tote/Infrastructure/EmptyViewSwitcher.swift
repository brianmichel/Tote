//
//  EmptyViewSwitcher.swift
//  Tote
//
//  Created by Brian Michel on 4/3/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class EmptyViewSwitcher {
    let emptyView: UIView
    let contentView: UIView

    private(set) var empty: Bool = true

    init(emptyView: UIView, contentView: UIView) {
        self.emptyView = emptyView
        self.contentView = contentView

        changeAlpha(for: empty)
        changeHidden(for: empty)
    }

    func set(empty: Bool, animated: Bool = true) {
        if self.empty == empty { return }

        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.changeAlpha(for: empty)
        }, completion: { [weak self] _ in
            self?.empty = empty
            self?.changeHidden(for: empty)
        })
    }

    private func changeAlpha(for empty: Bool) {
        emptyView.alpha = empty ? 1.0 : 0.0
        contentView.alpha = empty ? 0.0 : 1.0
    }

    private func changeHidden(for empty: Bool) {
        emptyView.isHidden = !empty
        contentView.isHidden = empty
    }
}
