//
//  BaseViewController.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import UIKit
import Combine

open class BaseViewController: UIViewController {
    var bag = Set<AnyCancellable>()
    
    func showAlert(
        title: String = "",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
