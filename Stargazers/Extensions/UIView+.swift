//
//  UIView+.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import UIKit

extension UIView {
    /// The `nib` having the name of the class as name
    class var nib: UINib {
        UINib(nibName: identifier, bundle: Bundle(for: classForCoder()))
    }
    
    /// The name of the class
    public static var identifier: String {
        String(describing: self)
    }    
}


// MARK: - Utilities
extension UIView {
    /// Shadow sizes
    enum ShadowSize {
        case none
        case small
        case medium
        case large
        
        fileprivate var radius: CGFloat {
            switch self {
            case .none:
                return 0
            case .small:
                return 2
            case .medium:
                return 5
            case .large:
                return 7
            }
        }
    }
    
    /// Add shadow to view using standard sizes
    /// - Parameters:
    ///   - size: shadow size
    ///   - shadowColor: shadow color
    ///   - opacity: shadow opacity
    func addShadow(size: ShadowSize, color: UIColor = .black, opacity: Float = 0.25) {
        let radius = size.radius
        //        let opacity: Float = (color.isLight(threshold: 0.28) ?? false) ? 0.7 : 0.35
        addShadow(ofColor: color,
                  radius: radius,
                  offset: .init(width: 0, height: 1),
                  opacity: size == .none ? 0 : opacity)
    }
    
    /// Add shadow to view.
    ///
    /// - Note: This method only works with non-clear background color, or if the view has a `shadowPath` set.
    /// See parameter `opacity` for detail.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5). It will also be affected by the `alpha` of `backgroundColor`
    func addShadow(
        ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5
    ) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        layer.masksToBounds = false
    }
    
    func removeShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.clear.cgColor
        layer.cornerRadius = 0.0
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.0
    }
}

// MARK: - Layout

extension UIView {
    func autoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
     Adds Autolayout constraints to fill `view` with `self`
     
     - parameter view: the UIView to fill
     - parameter insets: insets of `self` respect to `view`
     - parameter useSafeArea: if true use the safe area anchors
     - precondition: `self` and `view` must be in the same view hierachy
     */
    @available(iOS, introduced: 11.0)
    func fill(view: UIView, insets: UIEdgeInsets = .zero, useSafeArea: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        let leading = self.leadingAnchor.constraint(equalTo: useSafeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: insets.left)
        let bottom = self.bottomAnchor.constraint(equalTo: useSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: -insets.bottom)
        let trailing = self.trailingAnchor.constraint(equalTo: useSafeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, constant: -insets.right)
        let top = self.topAnchor.constraint(equalTo: useSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: insets.top)
        NSLayoutConstraint.activate([leading, bottom, trailing, top])
    }
    
    /**
     Adds Autolayout constraints to center `self` inside `view`
     
     - parameter view: the UIView to center in
     - parameter offset: the absolute offset from the center of `view`
     - precondition: `self` and `view` must be in the same view hierachy
     */
    func center(in view: UIView, offset: CGPoint = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        let centerHorizontally = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x)
        let centerVertically = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y)
        NSLayoutConstraint.activate([centerHorizontally, centerVertically])
    }

}
