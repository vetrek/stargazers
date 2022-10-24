//
//  CancellableTextField.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import UIKit

/// Custom UITextFiled 
class TextField: UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    // MARK: Private Properties
    
    private var kAssociationKeyMaxLength: Int = 0
    
    // MARK: Properties
    
    var maxLength: Int = 0
    var allowSpace: Bool = true
    var textDidChange: ((String?) -> Void)?
    var focusedBorderColor: UIColor = .Text.onPrimary {
        didSet {
            layer.borderColor = focusedBorderColor.cgColor
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func becomeFirstResponder() -> Bool {
        layer.borderWidth = 1.5
        layer.borderColor = focusedBorderColor.cgColor
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        layer.borderWidth = 0.2
        return super.resignFirstResponder()
    }
}

private extension TextField {
    func setup() {
        layer.borderWidth = 0.3
        backgroundColor = .Primary.normal
        tintColor = .Text.onPrimary
        layer.cornerRadius = 10
        layer.borderColor = UIColor.Text.onPrimary.cgColor
        setPadding(.both(8))
        
        addAction(for: .editingChanged) { [weak self] in
            guard let self = self else { return }
            
            if !self.allowSpace {
                self.text = self.text?.replacingOccurrences(of: " ", with: "")
            }
            
            defer { self.textDidChange?(self.text) }
            guard
                let prospectiveText = self.text,
                self.maxLength > 0,
                prospectiveText.count > self.maxLength
            else { return }
            
            let selection = self.selectedTextRange
            
            let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: self.maxLength)
            let substring = prospectiveText[..<indexEndOfText]
            self.text = String(substring)
            self.selectedTextRange = selection
        }
    }
}

extension TextField {
    func setPadding(_ side: PaddingSide) {
        switch side {
        case .left(let amount):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        case .right(let amount):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        case .both(let amount):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
