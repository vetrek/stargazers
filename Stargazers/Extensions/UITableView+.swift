//
//  UITableView+.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import UIKit

extension UITableView {
    
    /**
     Register a cell from its nib in `self` using the default `identifier`
     */
    func register(xibCell cell: UITableViewCell.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }
    
    /**
     Register a cell from its type in `self` using the default `identifier`
     */
    func register(cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    /**
     Register an header footer view from its nib in `self` using the default `identifier`
     */
    func register(xibHeaderFooterView view: UITableViewHeaderFooterView.Type) {
        register(view.nib, forHeaderFooterViewReuseIdentifier: view.identifier)
    }
    
    /**
     Register an header footer view from its type in `self` using the default `identifier`
     */
    func register(headerFooterViewClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: headerFooterViewClass.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        // swiftlint:disable:next force_cast
        dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
}
