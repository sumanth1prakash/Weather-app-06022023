//
//  Environments.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import SwiftUI
import Combine

extension EnvironmentValues {
    
    var viewLifecyclePublisherKey: AnyPublisher<ViewLifecycleEvents, Never>? {
        get { self[WeatherViewLifecyclePublisherKey.self] }
        set { self[WeatherViewLifecyclePublisherKey.self] = newValue }
    }
    
    var flowNavigationControllerKey: NavigationControllerWrapper? {
        get { self[FlowNavigationControllerKey.self] }
        set { self[FlowNavigationControllerKey.self] = newValue }
    }
}

extension View {
    func viewLifecyclePublisher(_ publisher: AnyPublisher<ViewLifecycleEvents, Never>?) -> some View {
        environment(\.viewLifecyclePublisherKey, publisher)
    }
    
    func flowNavigationController(_ controller: NavigationControllerWrapper) -> some View {
        environment(\.flowNavigationControllerKey, controller)
    }
}

private struct FlowNavigationControllerKey: EnvironmentKey {
    static let defaultValue: NavigationControllerWrapper? = nil
}

private struct WeatherViewLifecyclePublisherKey: EnvironmentKey {
    static let defaultValue: AnyPublisher<ViewLifecycleEvents, Never>? = nil
}


public enum ViewLifecycleEvents {
    case viewWillAppear(Bool)
    case viewDidAppear(Bool)
    case viewWillDisappear(Bool)
    case viewDidDisappear(Bool)
    case viewDidLoad
    
    var simplified: ViewLifecycleEventsSimplified {
        switch self {
        case .viewWillAppear:
            return .viewWillAppear
        case .viewDidAppear:
            return .viewDidAppear
        case .viewWillDisappear:
            return .viewWillDisappear
        case .viewDidDisappear:
            return .viewDidDisappear
        case .viewDidLoad:
            return .viewDidLoad
        }
    }
    
}

public enum ViewLifecycleEventsSimplified {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    case viewDidLoad
}

public class Screen_UIKitHost<Body: View>: UIViewController {
    
    let viewLifecycleEventsSubject: PassthroughSubject<ViewLifecycleEvents, Never>
    
    public var body: Body
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.viewLifecycleEventsSubject.send(.viewWillAppear(animated))
        }
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.viewLifecycleEventsSubject.send(.viewDidAppear(animated))
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.viewLifecycleEventsSubject.send(.viewWillDisappear(animated))
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.viewLifecycleEventsSubject.send(.viewDidDisappear(animated))
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.viewLifecycleEventsSubject.send(.viewDidLoad)
        }
             
    }
    
    public init(body: Body) {
        self.body = body
        viewLifecycleEventsSubject = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var flowNavigationController: UINavigationController? {
        return self.navigationController
    }
    
    var navigationBarBackdropView: UIView?
    
    func host(topEdgeIgnoresSafeArea: Bool = false) {
        
        let backdropView = UIView()
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdropView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: backdropView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backdropView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backdropView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backdropView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
        backdropView.backgroundColor = .white
        self.navigationBarBackdropView = backdropView
        let wrappedNav = NavigationControllerWrapper.init(weakRef: self.flowNavigationController)
        let b1 = body.flowNavigationController(wrappedNav)
        let b2 = b1.viewLifecyclePublisher(self.viewLifecycleEventsSubject.eraseToAnyPublisher())
        let hosting = UIHostingController(rootView: b2)
        let parent = self
        let hostingView = hosting.view!
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        addChild(hosting)
        hosting.didMove(toParent: parent)
        backdropView.addSubview(hostingView)
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            {
                let c: NSLayoutConstraint
                if topEdgeIgnoresSafeArea {
                    c = NSLayoutConstraint(item: hostingView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
                } else {
                    c = NSLayoutConstraint(item: hostingView, attribute: .top, relatedBy: .equal, toItem: margins, attribute: .topMargin, multiplier: 1.0, constant: 0)
                }
                return c
            }(),
            NSLayoutConstraint(item: hostingView, attribute: .leading, relatedBy: .equal, toItem: backdropView, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: hostingView, attribute: .trailing, relatedBy: .equal, toItem: backdropView, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: hostingView, attribute: .bottom, relatedBy: .equal, toItem: backdropView, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
        
        
    }
    
    func clearBackButtonText(_ self: UIViewController) {
        self.title = ""
    }
    
    func set(navigationItem: UINavigationItem, title: String, color: UIColor) {
        let titleLabel = UILabel()
        titleLabel.attributedText = .init(string: title, attributes: [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
        ])
        navigationItem.titleView = titleLabel
    }
    
    func remove1pxSeparatorLineInNavigationBar(_ navigationBar: UINavigationBar, value: Bool) {
        navigationBar.clipsToBounds = value
    }
    
    func applyBaseStyle(_ navigationBar: UINavigationBar) {
        remove1pxSeparatorLineInNavigationBar(navigationBar, value: false)
    }
    
    func applyStyle(_ navigationBar: UINavigationBar) {
        remove1pxSeparatorLineInNavigationBar(navigationBar, value: true)
    }
    

}

//to avoid retain-cycles
public class NavigationControllerWrapper {
    
    weak var navigationController: UINavigationController?
    public init(
        weakRef: UINavigationController?
    ) {
        self.navigationController = weakRef
    }
    
}
