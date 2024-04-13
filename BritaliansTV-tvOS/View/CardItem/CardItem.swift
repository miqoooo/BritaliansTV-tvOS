//
//  CardItem.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import SwiftUI
import Kingfisher

struct CardItem: View {
    @FocusState var isFocused: Bool
    
    var title: String
    var imagePath: String?
    let ifPressed: () -> Void
    let ifFocused: () -> Void
    let size: CGSize = .init(width: 220, height: 310)
    
    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                ifPressed()
            }
        }, label: {
            VStack {
                KFImage.url(URL(string: imagePath ?? ""))
                    .resizable()
                    .placeholder({ Image("cardPlaceholder") })
                    .fade(duration: 0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: size.width, height: size.height)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 5)
//                            .inset(by: -10)
//                            .stroke(lineWidth: 4)
//                            .fill(isFocused ? .white : .clear)
//                    }
            }
        })
        .onChange(of: isFocused, perform: { _ in
            if self.isFocused {
                DispatchQueue.main.async {
                    ifFocused()
                }
            }
        })
        .buttonStyle(TvButtonStyle(focusAnimation: nil))
        .focused($isFocused)
        //.buttonStyle(.card)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
    }
}
