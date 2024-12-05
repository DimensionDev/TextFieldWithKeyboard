# Usage

```
@State private var text: String = ""
@FocusState private var isActive: Bool

YYTextFieldWithKeyboard {
    TextField("", text: $text)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(width: 150)
        .focused($isActive)
} keyboard: {
    CustomNumberKeyboard(text: $text, isActive: $isActive, config: .default)
}
```
