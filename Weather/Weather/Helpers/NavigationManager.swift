//
//  NavigationManager.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import UIKit

public enum NavigationType {
    case push
    case present(mode: PresentationMode)
    case replace
}

public enum PresentationMode {
    case fullScreen
    case automatic
}

private var appWindow: UIWindow = {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return UIWindow(windowScene: windowScene)
        }
        return UIWindow()
}()

public class NavigationManager {
    
    public static let shared = NavigationManager()
    
    public var rootViewController: UIViewController? {
        appWindow.rootViewController
    }
    
    public func setAppWindow(window: UIWindow) {
        appWindow = window
    }
    
    public func performNavigation(to viewController: UIViewController, navigationType: NavigationType, animated: Bool = true, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            switch navigationType {
            case .push:
                guard let topViewController = self.topViewController() else { return }
                topViewController.navigationController?.pushViewController(viewController, animated: animated)
                guard let completion = completion else { return }
                completion()
            case .present(let mode):
                guard let topViewController = self.topViewController() else { return }
                if mode == .fullScreen { viewController.modalPresentationStyle = .fullScreen }
                topViewController.present(viewController, animated: animated, completion: completion)
            case .replace:
                appWindow.rootViewController = viewController
                appWindow.makeKeyAndVisible()
                guard let completion = completion else { return }
                completion()
            }
        }
    }
    
   
    private func topViewController(controller: UIViewController? = UIApplication.shared.connectedScenes
                                        .first(where: { $0.activationState == .foregroundActive })
                                        .map({ $0 as? UIWindowScene })
                                        .flatMap({ $0?.windows.first { $0.isKeyWindow } })
                                        .flatMap({ $0.rootViewController })) -> UIViewController? {
                
       if let navigationController = controller as? UINavigationController {
           return topViewController(controller: navigationController.visibleViewController)
       }

       if let presented = controller?.presentedViewController {
           return topViewController(controller: presented)
       }

       return controller
   }
}
