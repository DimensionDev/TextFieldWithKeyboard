//
//  KeyboardViews.swift
//  YYTextfieldWithKeyboard
//
//  Created by ChuanqingYang on 2024/12/5.
//
import SwiftUI

@available(iOS 16.0, *)
public struct CustomNumberKeyboard: View {
    
    @Binding public var text: String
    
    @FocusState.Binding public var isActive: Bool
    
    public var config: Config
    
    public struct Config : Sendable{
        public static let `default`: Config = .init()
        
        public var baseStyle: BaseStyle = .base(.default)
        
        public enum BaseStyle: Sendable {
            case base(_ config: BaseStyleConfig)
            
            public struct BaseStyleConfig: Sendable {
                public static let `default`: BaseStyleConfig = .init()
                
                public var backgroundColor: Color = Color.gray.opacity(0.5)
            }
        }
        
        public var layoutStyle: LayoutStyle = .default
        
        public struct LayoutStyle : Sendable{
            public static let `default`: LayoutStyle = .init()
            
            var keyboardVericalSpacing: CGFloat = 15
            
            var keyboardVerticalPadding: CGFloat = 15
            
            var buttonHorizontalPadding: CGFloat = 24
        }
        
        var numberStyle: NumberStyle = .normal(.default)
        
        public enum NumberStyle : Sendable{
            case normal(_ config: NumberStyleConfig)
            
            public struct NumberStyleConfig: Sendable {
                public static let `default`: NumberStyleConfig = .init()
                
                public var numberFont: Font = .title3
                public var fontWeight: Font.Weight = .semibold
                public var numberForegroundColor: Color = Color.white
            }
        }
        
        var buttonStyle: ButtonStyle = .rounded(.default)
        
        public enum ButtonStyle : Sendable{
            case capsule(_ config: ButtonStyleConfig)
            case rounded(_ config: ButtonStyleConfig)
            
            public struct ButtonStyleConfig : Sendable{
                public static let `default`: ButtonStyleConfig = .init()
                
                public var buttonTitle: String = "Confirm"
                public var buttonHeight: CGFloat = 48
                public var buttonCornerRadius: CGFloat = 8
                public var buttonTitleFont: Font = .title3
                public var buttonTitleFontWeight: Font.Weight = .semibold
                public var buttonForegroundColor: Color = Color.white
                public var buttonBackgroundColor: Color = Color.clear
                public var buttonBoarderColor: Color = Color.gray
                public var buttonBoarderWidth: CGFloat = 1
            }
        }
    }
    
    public enum KeyboardType {
        case number
        case point
        case delete
    }
    
    public init(text: Binding<String>, isActive: FocusState<Bool>.Binding, config: Config) {
        _text = text
        _isActive = isActive
        self.config = config
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 3), spacing: config.layoutStyle.keyboardVericalSpacing) {
                ForEach(1...9, id: \.self) { index in
                    ButtonView("\(index)", type: .number)
                }
                
                ButtonView(".", type: .point)
                
                ButtonView("0", type: .number)
                
                ButtonView("delete.backward.fill", type: .delete)
            }
            .padding(.vertical, config.layoutStyle.keyboardVericalSpacing)
            
            ConfirmButton()
                .padding(.horizontal, config.layoutStyle.buttonHorizontalPadding)
            
            Spacer()
        }
        .background {
            switch config.baseStyle {
            case let .base(style):
                style.backgroundColor
                    .ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    func ConfirmButton() -> some View {
        Button {
            isActive = false
        } label: {
            switch config.buttonStyle {
            case .capsule(let style):
                Capsule()
                    .stroke(style.buttonBoarderColor, lineWidth: style.buttonBoarderWidth)
                    .background {
                        style.buttonBackgroundColor
                    }
                    .overlay {
                        Text(style.buttonTitle)
                            .font(style.buttonTitleFont)
                            .fontWeight(style.buttonTitleFontWeight)
                            .foregroundStyle(style.buttonForegroundColor)
                    }
                    .frame(height: style.buttonHeight)
            case .rounded(let style):
                RoundedRectangle(cornerRadius: style.buttonCornerRadius, style: .continuous)
                    .stroke(style.buttonBoarderColor, lineWidth: style.buttonBoarderWidth)
                    .background {
                        style.buttonBackgroundColor
                    }
                    .overlay {
                        Text(style.buttonTitle)
                            .font(style.buttonTitleFont)
                            .fontWeight(style.buttonTitleFontWeight)
                            .foregroundStyle(style.buttonForegroundColor)
                    }
                    .frame(height: style.buttonHeight)
            }
        }

    }
    
    @ViewBuilder
    func ButtonView(_ value: String, type: KeyboardType) -> some View {
        Button {
            switch type {
            case .number:
                if text.hasPrefix("0") && !text.hasPrefix("0.") && value == "0" {
                    return
                }
                text += value
            case .point:
                if text.isEmpty && value == "." {
                    text = "0."
                    return
                }
                
                if text.contains(".") && value == "." {
                    return
                }
                
                text += value
            case .delete:
                if !text.isEmpty {
                    text.removeLast()
                }
            }
        } label: {
            switch type {
            case .number, .point:
                switch config.numberStyle {
                case .normal(let style):
                    Text(value)
                        .font(style.numberFont)
                        .fontWeight(style.fontWeight)
                        .foregroundStyle(style.numberForegroundColor)
                }
            case .delete:
                Image(systemName: value)
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
            }
        }

    }
}
