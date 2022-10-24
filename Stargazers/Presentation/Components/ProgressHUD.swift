//
//  ProgressHUD.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 22/10/22.
//

import UIKit
import SmartNet

protocol HUD {
    static func show()
    static func dismiss()
}


/// Progress HUD view
final class ProgressHUD: SNProgressHUD {
    static private(set) var shared = ProgressHUD()
    private init() {}
    
    // MARK: Private Properties
    
    private lazy var view = LoadingView()
    private var showCounter: Int = 0
    
    /// Show a Progress HUD in Overlay
    func show() {
        DispatchQueue.main.async { [weak self] in
            defer { self?.showCounter += 1 }
            guard self?.showCounter == .zero else { return }
            self?.view.show()
        }
    }
    
    /// Dismiss the Overlay
    func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [weak self] in
            guard let self = self else { return }
            defer { self.showCounter = max(.zero, self.showCounter - 1) }
            guard self.showCounter == 1 else { return }
            self.view.dismiss()
        }
    }
}

final private class LoadingView: OverlayViewController {
    private let loadingAnimationView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.tintColor = .Secondary.normal
        return view
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.autoLayout()
        view.addShadow(size: .large)
        return view
    }()
    
    private var blurView = BlurEffectView()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        
        // Centered Card
        view.addSubview(cardView)
        cardView.center(in: view)
        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: 150),
            cardView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        // Loading View animation
        cardView.addSubview(loadingAnimationView)
        loadingAnimationView.center(in: cardView)
        NSLayoutConstraint.activate([
            loadingAnimationView.widthAnchor.constraint(equalTo: cardView.widthAnchor),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func show() {
        loadingAnimationView.stopAnimating()
        blurView.removeFromSuperview()
        blurView = BlurEffectView()
        view.insertSubview(blurView, at: 0)
        
        blurView.fill(view: view, useSafeArea: false)
        
        showOverlay(duration: 0.12, shouldDismissOnTap: false)
        loadingAnimationView.startAnimating()
    }
    
    func dismiss() {
        closeOverlay(duration: 0.12) { [weak self] in
            self?.blurView.removeFromSuperview()
            self?.loadingAnimationView.stopAnimating()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

final class BlurEffectView: UIVisualEffectView {
    
    var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    var onClick: (() -> Void)?
    
    override func didMoveToSuperview() {
        backgroundColor = .clear
        setupBlur()
        setupClick()
    }
    
    private func setupBlur() {
        animator.stopAnimation(true)
        effect = nil
        
        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: AppStyle.darkMode ? .light : .dark)
        }
        animator.fractionComplete = 0.08   // This is your blur intensity in range 0 - 1
    }
    
    private let blackView = UIView()
    
    private func setupClick() {
        guard onClick != nil else { return }
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBlurView)))
    }
    
    @objc private func didTapBlurView() {
        onClick?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blackView.removeFromSuperview()
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentView.addSubview(blackView)
        blackView.frame = frame
    }
    
    deinit {
        animator.stopAnimation(true)
    }
}
