//
//  UIControl+.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import UIKit

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        class ClosureSleeve {
            let closure: () -> Void
            
            init(_ closure: @escaping () -> Void) {
                self.closure = closure
            }
            
            @objc func invoke() {
                closure()
            }
        }
        
        let sleeve = ClosureSleeve(closure)
        removeTarget(nil, action: nil, for: controlEvents)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
