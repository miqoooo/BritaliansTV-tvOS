//
//  Font.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import SwiftUI

extension Font {
    public static func raleway(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        var fontName = "Raleway-Regular"
        
        switch weight {
        case .black:        fontName = "Raleway-Black"
        case .heavy:        fontName = "Raleway-ExtraBold"
        case .bold:         fontName = "Raleway-Bold"
        case .semibold:     fontName = "Raleway-SemiBold"
        case .regular:      fontName = "Raleway-Regular"
        case .medium:       fontName = "Raleway-Medium"
        case .light:        fontName = "Raleway-Light"
        case .ultraLight:   fontName = "Raleway-Light"
        case .thin:         fontName = "Raleway-Thin"
        default: break
        }
        
        let font = Font.custom(fontName, size: size)
        return font
    }
}

extension UIFont {
    public static func raleway(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> UIFont {
        var fontName = "Raleway-Regular"
        
        switch weight {
        case .black:        fontName = "Raleway-Black"
        case .heavy:        fontName = "Raleway-ExtraBold"
        case .bold:         fontName = "Raleway-Bold"
        case .semibold:     fontName = "Raleway-SemiBold"
        case .regular:      fontName = "Raleway-Regular"
        case .medium:       fontName = "Raleway-Medium"
        case .light:        fontName = "Raleway-Light"
        case .ultraLight:   fontName = "Raleway-Light"
        case .thin:         fontName = "Raleway-Thin"
        default: break
        }
        
        let font = UIFont(name: fontName, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
}

