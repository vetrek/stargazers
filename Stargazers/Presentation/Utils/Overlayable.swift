//
//  Overlayable.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 22/10/22.
//

import Foundation
import UIKit

public protocol Overlayable: UIGestureRecognizerDelegate { }

public protocol OverlayableDelegate: AnyObject {
    func overlayWillDisappear()
}

/// Utility class to show an UIViewController in Overlay using a new Window
open class OverlayViewController: UIViewController, Overlayable {
    public weak var overlayDelegate: OverlayableDelegate?
    
    private lazy var alertWindow: UIWindow = {
        var window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes

            let windowScene = scenes.count == 1 ?
            scenes.filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }.first :
            scenes.filter { $0.activationState == .foregroundActive }.first
            
            if let windowScene = windowScene as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
                window.frame = UIScreen.main.bounds
            }
        }
        window.windowLevel = .alert + 1
        return window
    }()
    
    private var blurView = BlurEffectView()
    
    /// Show the Overlay in a new UIWindow
    public func showOverlay(
        duration: TimeInterval = 0.15,
        shouldDismissOnTap: Bool = true,
        blurBackground: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        alertWindow.rootViewController = self
        alertWindow.makeKeyAndVisible()
        view.alpha = 0
        UIView.animate(withDuration: duration) {
            self.view.alpha = 1
        }
        
        UIView.animate(withDuration: duration) {
            self.view.alpha = 1
        } completion: { _ in
            completion?()
        }
        
        if blurBackground {
            blurView = BlurEffectView()
            view.insertSubview(blurView, at: 0)
        }
        
        if shouldDismissOnTap {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(closeOverlayWithTap))
//            gesture.cancelsTouchesInView = false
            gesture.delegate = self
            view.addGestureRecognizer(gesture)
        }
    }
    
    /// Remove the Overlay
    @objc public func closeOverlayWithTap(duration: TimeInterval = 0.15) {
        closeOverlay(duration: duration, completion: nil)
    }
    
    /// Remove the Overlay
    @objc public func closeOverlay(
        duration: TimeInterval = 0.15,
        completion: (() -> Void)?
    ) {
        overlayDelegate?.overlayWillDisappear()
        view.gestureRecognizers?.forEach {
            view.removeGestureRecognizer($0)
        }
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 2,
                       initialSpringVelocity: 0) {
            self.view.alpha = 0
            
        } completion: { [weak self] (_) in
            guard let self = self else { return }
            self.view.transform = .identity
            self.alertWindow.isHidden = true
            self.alertWindow.rootViewController = nil
            self.blurView.removeFromSuperview()
            completion?()
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view?.isDescendant(of: blurView) == true || touch.view == view
    }
}
