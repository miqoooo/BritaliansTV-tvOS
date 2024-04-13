//
//  ButtonStyle.swift
//  BritaliansTV
//
//  Created by miqo on 08.11.23.
//

import SwiftUI

struct TvButtonStyle: ButtonStyle {
    @Environment(\.isFocused) var isFocused
    
    var border: CGFloat = 4
    
    var cornerRadius: CGFloat = 0
    
    var defaultScale: CGFloat = 1
    var focusedScale: CGFloat = 1
    var pressedScale: CGFloat = 0.9
    
    var circleStyle: Bool = false
    
    var focusAnimation: Animation? = .default
    var pressAnimation: Animation? = .default
    
    @ViewBuilder
    private func shape(configuration: Configuration) -> some View {
        if circleStyle {
            configuration.label
                .clipShape(Circle())
                .overlay {
                    if isFocused {
                        Circle()
                            .inset(by: -1.1*border)
                            .stroke(lineWidth: border)
                    }
                }
        }
        else {
            configuration.label
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay {
                    if isFocused {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .inset(by: -1.1*border)
                            .stroke(lineWidth: border)
                    }
                }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        shape(configuration: configuration)
            .scaleEffect(isFocused ? focusedScale : defaultScale)
            .scaleEffect(configuration.isPressed ? pressedScale : defaultScale)
            .animation(focusAnimation, value: isFocused)
            .animation(pressAnimation, value: configuration.isPressed)
    }
}
