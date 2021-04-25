//
//  File.swift
//  
//
//  Created by Jacob Whitehead on 25/04/2021.
//

import UIKit
import ThemeKit

extension Array where Element: UIView {

    public func hStack(spacing: CGFloat = Theme.constant(for: .padding),
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return UIStackView.make(views: self, spacing: spacing, axis: .horizontal, alignment: alignment, distribution: distribution)
    }

    public func vStack(spacing: CGFloat = Theme.constant(for: .padding),
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill,
                       edgeInsets: NSDirectionalEdgeInsets = .zero) -> UIStackView {
        let stack = UIStackView.make(views: self, spacing: spacing, axis: .vertical, alignment: alignment, distribution: distribution)
        stack.directionalLayoutMargins = edgeInsets
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }

    public func verticallyCenteredInStack(spacing: CGFloat = Theme.constant(for: .padding)) -> UIStackView {
        let topSpacer = UIView()
        let bottomSpacer = UIView()
        let views = [topSpacer] + self + [bottomSpacer]
        let contentStack = views.vStack(spacing: spacing)
        topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor, multiplier: 1).isActive = true
        return contentStack
    }
    
}

extension UIStackView {
    
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    public static func make(views: [UIView],
                            spacing: CGFloat,
                            axis: NSLayoutConstraint.Axis,
                            alignment: UIStackView.Alignment,
                            distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.axis = axis
        return stackView
    }
    
}
