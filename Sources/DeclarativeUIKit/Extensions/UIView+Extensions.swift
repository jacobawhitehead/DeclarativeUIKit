//
//  UIView+Extensions.swift
//  
//
//  Created by Jacob Whitehead on 25/04/2021.
//

import UIKit
import ThemeKit

public protocol Anchorable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: Anchorable { }
extension UILayoutGuide: Anchorable { }

// MARK: - Styling

public extension UIView {
    
    @discardableResult
    func backgroundColor(_ context: ColorContext) -> Self {
        backgroundColor = Theme.color(for: context)
        return self
    }
    
    @discardableResult
    func cardStyle() -> UIView {
        rounded().shadow()
    }
    
    @discardableResult
    func cardStyleWithBackground(_ context: ColorContext = .backgroundSecondary) -> UIView {
        cardStyle().backgroundColor(context)
    }
    
    @discardableResult
    func cardStyleWithGradient(_ colors: [UIColor]) -> UIView {
        cardStyle().gradientBackground(colors)
    }

    @discardableResult
    func rounded(radius: CGFloat = Theme.constant(for: .cornerRadius),
                 corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,
                                          .layerMinXMaxYCorner, .layerMinXMinYCorner]) -> Self {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        return self
    }
    
    @discardableResult
    func shadow(radius: CGFloat = Theme.constant(for: .shadowRadius),
                offset: CGSize = .zero, colorContext: ColorContext = .shadow) -> UIView {
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        let color = Theme.color(for: colorContext)
        layer.shadowColor = color.resolvedColor(with: traitCollection).cgColor
        layer.borderColor = color.resolvedColor(with: traitCollection).cgColor
        return self
    }
    
    @discardableResult
    func gradientBackground(_ colors: [UIColor]) -> Self {
        let gradient = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer ?? CAGradientLayer()
        
        gradient.colors = colors.map { $0.cgColor }
        gradient.frame = bounds
        gradient.masksToBounds = true
        gradient.cornerRadius = layer.cornerRadius
        gradient.maskedCorners = layer.maskedCorners
        layer.insertSublayer(gradient, at: 0)
        return self
    }
    
}

// MARK: - Layout and constraints

public extension UIView {
    
    func pin(to anchorable: Anchorable, padding: CGFloat = 0, lowPriorityBottom: Bool = false) {
        pin(to: anchorable, topInset: padding, leadingInset: padding, bottomInset: padding, trailingInset: padding, lowPriorityBottom: lowPriorityBottom)
    }

    func pin(to anchorable: Anchorable, topInset: CGFloat = 0, leadingInset: CGFloat = 0, bottomInset: CGFloat = 0, trailingInset: CGFloat = 0, lowPriorityBottom: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = anchorable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: anchorable.leadingAnchor, constant: leadingInset),
            anchorable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingInset),
            topAnchor.constraint(equalTo: anchorable.topAnchor, constant: topInset),
            bottomConstraint
        ])
        if lowPriorityBottom {
            bottomConstraint.priority = .defaultHigh
        }
    }
    
    @discardableResult
    func constrainToSize(_ size: CGSize) -> Self {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
        return self
    }
    
    @discardableResult
    func wrapInView(topInset: CGFloat = 0, leadingInset: CGFloat = 0, bottomInset: CGFloat = 0, trailingInset: CGFloat = 0) -> UIView {
        let view = UIView()
        view.addSubview(self)
        pin(to: view, topInset: topInset, leadingInset: leadingInset, bottomInset: bottomInset, trailingInset: trailingInset)
        return view
    }
    
}
