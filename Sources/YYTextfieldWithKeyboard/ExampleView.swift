//
//  ExampleView.swift
//  YYTextfieldWithKeyboard
//
//  Created by ChuanqingYang on 2024/12/5.
//

import SwiftUI

@available(iOS 16.0, *)
public struct ExampleView: View {
    @State private var text: String = ""
    @FocusState var isActive: Bool
    public var body: some View {
        YYTextFieldWithKeyboard {
            TextField("", text: $text)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .frame(width: 150)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary)
                }
        } keyboard: {
            CustomNumberKeyboard(text: $text, isActive: $isActive, config: .default)
        }
        
    }
}

@available(iOS 16.0, *)
#Preview {
    ExampleView()
}
