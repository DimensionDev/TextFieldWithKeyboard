//
//  BaseView.swift
//  YYTextfieldWithKeyboard
//
//  Created by ChuanqingYang on 2024/12/5.
//

import SwiftUI

@available(iOS 16.0, *)
public struct BaseBlurView: UIViewRepresentable {
    @Environment(\.colorScheme) private var colorScheme
    public init(style: UIBlurEffect.Style? = nil) {
        self.style = style
    }

    let style: UIBlurEffect.Style?

    public func makeUIView(context: Context) -> UIVisualEffectView {
        if let style = self.style {
           return UIVisualEffectView(effect: UIBlurEffect(style: style))
        } else {
            let style: UIBlurEffect.Style = colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight
           return UIVisualEffectView(effect: UIBlurEffect(style: style))
        }
    }

    public func updateUIView( _ view: UIVisualEffectView, context _: Context) {
        view.effect = UIBlurEffect(style: colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(style: style ?? (self.colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight))
    }
}

@available(iOS 16.0, *)
extension BaseBlurView {
    public final class Coordinator {
        fileprivate init(style: UIBlurEffect.Style) {
            self.style = style
        }

        let style: UIBlurEffect.Style
    }
}
