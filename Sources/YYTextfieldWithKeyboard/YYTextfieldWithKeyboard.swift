// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 16.0, *)
public struct YYTextFieldWithKeyboard<TextField: View, Keyboard: View>: UIViewControllerRepresentable {
    
    @ViewBuilder var textfield: TextField
    @ViewBuilder var keyboard: Keyboard
    
    public init(
        @ViewBuilder textfield: () -> TextField,
        @ViewBuilder keyboard: () -> Keyboard
    ) {
        self.textfield = textfield()
        self.keyboard = keyboard()
    }
    
    public func makeUIViewController(context: Context) -> UIHostingController<TextField> {
        let controller = UIHostingController(rootView: textfield)
        
        DispatchQueue.main.async {
            if let textfield = controller.view.allSubviews.first(where: { $0 is UITextField }) as? UITextField, textfield.inputView == nil {
                // place inputview
                let inputController = UIHostingController(rootView: keyboard)
                inputController.view.backgroundColor = .clear
                inputController.view.frame = .init(origin: .zero, size: CGSize(width: inputController.view.intrinsicContentSize.width, height: inputController.view.intrinsicContentSize.height + SafeAreaHelper.bottomSafeAreaHeight()))
                textfield.inputView = inputController.view
                textfield.reloadInputViews()
            }
        }
        
        controller.view.backgroundColor = .clear
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIHostingController<TextField>, context: Context) {
        
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIHostingController<TextField>, context: Context) -> CGSize? {
        return uiViewController.view.intrinsicContentSize
    }
}

// Finding UITextField from UIHostingController
fileprivate extension UIView {
    var allSubviews: [UIView] {
        return self.subviews.flatMap({ [$0] + $0.allSubviews })
    }
}

fileprivate struct SafeAreaHelper {
    @MainActor static func getSafeAreaInsets() -> UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }

    @MainActor static func bottomSafeAreaHeight() -> CGFloat {
        return getSafeAreaInsets().bottom
    }

    @MainActor static func topSafeAreaHeight() -> CGFloat {
        return getSafeAreaInsets().top
    }
}

