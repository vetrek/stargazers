//
//  FlowCoordinator.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation
import UIKit

private struct CoordinatorObjectKey {
    static var sourceNavigationController = "coordinator_source_navigation_controller"
    static var modalNavigationController = "coordinator_modal_navigation_controller"
    static var rootViewController = "coordinator_root_view_controller"
}

protocol FlowCoordinator: AnyObject {
    init()
    init(navigationController: UINavigationController?)
}

extension FlowCoordinator {
    init(navigationController: UINavigationController?) {
        self.init()
        objc_setAssociatedObject(
            self,
            &CoordinatorObjectKey.sourceNavigationController,
            navigationController,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// The Flow root UIViewController
    var coordinatorRoot: UIViewController? {
        objc_getAssociatedObject(self, &CoordinatorObjectKey.rootViewController) as? UIViewController
    }
    
    /// The UINavigationController passed during the Coordinator intialization
    var sourceNavigationController: UINavigationController? {
        objc_getAssociatedObject(self, &CoordinatorObjectKey.sourceNavigationController) as? UINavigationController
    }
    
    /// The UINavigationController that is being used to handle the navigation
    /// This is equal to the `sourceNavigationController` if the flow is started normally
    /// or is equal to a new `UINavigationController`if started modally.
    var navigationController: UINavigationController? {
        guard
            let navController = objc_getAssociatedObject(
                self,
                &CoordinatorObjectKey.modalNavigationController
            ) as? UINavigationController
        else {
            return objc_getAssociatedObject(
                self,
                &CoordinatorObjectKey.sourceNavigationController
            ) as? UINavigationController
        }
        return navController
    }
    
    /// Return `true` if the Coordinator was started using `startModalFlow` or `false` if started with `startFlow`
    var isModal: Bool { navigationController !== sourceNavigationController }
    
    /// Pop to the UIViewController which started this Flow.
    /// If this was started as a Modal with `startModalFlow` it will simply dismiss it.
    func closeFlow(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard !isModal else {
            sourceNavigationController?.dismiss(animated: animated, completion: completion)
            return
        }
        
        guard
            let viewController = coordinatorRoot,
            let navController = navigationController,
            let index = navController.viewControllers.firstIndex(of: viewController)
        else { return }
        
        objc_setAssociatedObject(
            self,
            &CoordinatorObjectKey.rootViewController,
            nil,
            .OBJC_ASSOCIATION_ASSIGN
        )
        
        let destinationViewController = index == 0 ? viewController : navController.viewControllers[index - 1]
        navigationController?.popToViewController(
            destinationViewController,
            animated: animated
        )
    }
    
    /// Pop to the root UIViewController
    func popToCoordinatorRoot() {
        guard let viewController = coordinatorRoot else {
            return
        }
        
        navigationController?.popToViewController(viewController, animated: true)
    }
}

extension FlowCoordinator {
    
    /// Functions used to start the flow which will push the first UIViewController
    /// - Parameters:
    ///   - viewController: UIViewController to pushg
    ///   - animated: animation
    ///   - completion: completion
    func startFlow(
        with viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        objc_setAssociatedObject(
            self,
            &CoordinatorObjectKey.rootViewController,
            viewController,
            .OBJC_ASSOCIATION_ASSIGN
        )
        
        push(
            viewController,
            animated: animated,
            completion: completion
        )
    }
    
    /// Start the Flow as a Modal
    /// - Parameters:
    ///   - viewController: Flow root UIViewController
    ///   - animated: animation flag
    ///   - modalPresentationStyle: modal presentation style
    ///   - completion: completion
    func startModalFlow(
        with viewController: UIViewController,
        animated: Bool = true,
        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
        completion: (() -> Void)? = nil
    ) {
        let modalNavigationController = UINavigationController(rootViewController: viewController)
        modalNavigationController.modalPresentationStyle = modalPresentationStyle
        present(modalNavigationController, animated: animated, completion: completion)
        
        objc_setAssociatedObject(
            self,
            &CoordinatorObjectKey.rootViewController,
            viewController,
            .OBJC_ASSOCIATION_ASSIGN
        )
        
        objc_setAssociatedObject(
            self,
            &CoordinatorObjectKey.modalNavigationController,
            modalNavigationController,
            .OBJC_ASSOCIATION_ASSIGN
        )
    }
    
    /// Present a UIVIewController modally
    /// - Parameters:
    ///   - viewController: UIViewController to present
    ///   - animated: animation flag
    ///   - completion: completion
    func present(
        _ viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        navigationController?.present(viewController, animated: animated, completion: completion)
    }
    
    /// Push a UIViewController
    /// - Parameters:
    ///   - viewController: UIViewController to push
    ///   - animated: animation flag
    ///   - completion: completion
    func push(
        _ viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        navigationController?.pushViewController(viewController, animated: animated, completion: completion)
    }
    
    /// Pop UIVIewController from the navigation stack
    /// - Parameters:
    ///   - animated: animatio flag
    ///   - completion: completion
    func pop(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        if navigationController?.viewControllers.last === coordinatorRoot {
            objc_setAssociatedObject(
                self,
                &CoordinatorObjectKey.rootViewController,
                nil,
                .OBJC_ASSOCIATION_ASSIGN
            )
        }
        navigationController?.popViewController(animated: animated, completion: nil)
    }
    
    /// Dismiss presented ViewController
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
}

extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        pushViewController(viewController, animated: animated)
        guard
            animated,
            let coordinator = transitionCoordinator
        else {
            DispatchQueue.main.async { completion?() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
    
    func popViewController(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        popViewController(animated: animated)
        guard
            animated,
            let coordinator = transitionCoordinator
        else {
            DispatchQueue.main.async { completion?() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
}
