//
//  CancellableTextField.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import UIKit

/// Custom TextField with side button to clear its text
class CancellableTextField: TextField {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        clearButtonMode = .whileEditing
        rightViewMode = .never
    }
    
    private func tintClearImage() {
        for view in subviews where view is UIButton {
            let button = view as! UIButton
            if let image = button.image(for: .highlighted) {
                button.setImage(image.withTintColor(.Secondary.light), for: .normal)
                button.setImage(image.withTintColor(.Secondary.light), for: .highlighted)
            }
        }
    }
}
