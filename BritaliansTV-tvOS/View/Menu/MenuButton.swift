//
//  MenuButton.swift
//  DemoApp
//
//  Created by miqo on 11.09.23.
//

import SwiftUI

struct MenuButton: View {
    @EnvironmentObject private var menuVM: MenuVM
    @FocusState private var isFocused: Bool
    
    private var name: String
    private var image: String
    private var action: () -> Void
    private var isSelected: Bool
    
    private let focusedColor: Color = .white
    private let defaultColor: Color = .gray
    private let contentHeight: CGFloat = 45
    private let fontSize: CGFloat = 35
    
    var unfocused: Bool {
        return menuVM.opened && !isFocused
    }
    var focused: Bool {
        return !menuVM.opened || isFocused
    }
    
    init(
        name: String,
        image: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.name = name
        self.image = image
        self.action = action
        self.isSelected = isSelected
    }
    
    var body: some View {
        Button(action: action, label: {
            Label {
                Text(name)
                    .foregroundStyle(isFocused ? focusedColor : defaultColor)
            } icon: {
                ZStack {
                    Image(image + "_unfocus")
                        .resizable().scaledToFit()
                        .frame(width: contentHeight, height: contentHeight)
                        .opacity(unfocused ? 1 : 0)
                    Image(image)
                        .resizable().scaledToFit()
                        .frame(width: contentHeight, height: contentHeight)
                        .opacity(focused ? 1 : 0)
                }
            }
            .labelStyle(MenuLabelStyle(contentHeight: contentHeight, fontSize: fontSize))
        })
        .focused($isFocused)
        .buttonStyle(TvButtonStyle(border: 0, focusedScale: 1))
        .frame(minHeight: contentHeight, alignment: .leading)
    }
}

struct MenuLabelStyle: LabelStyle {
    @EnvironmentObject private var menuVM: MenuVM
    
    private let contentHeight: CGFloat
    private let fontSize: CGFloat
    private let spacing: CGFloat = 40
    
    init(contentHeight: CGFloat, fontSize: CGFloat) {
        self.contentHeight = contentHeight
        self.fontSize = fontSize
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
                //.frame(width: contentHeight, height: contentHeight, alignment: .leading)
            if menuVM.opened {
                configuration.title
                    .font(.raleway(size: fontSize, weight: .semibold))
            }
        }
    }
}
