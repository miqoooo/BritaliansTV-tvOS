//
//  CardItem.swift
//  BritaliansTV
//
//  Created by miqo on 07.11.23.
//

import SwiftUI
import Kingfisher

struct PosterCardItem: View {
    @FocusState var isFocused: Bool
    
    var imagePath: String?
    var size: CGSize = CGSize(width: 220, height: 310)
    let ifPressed: (() -> Void)
    let ifFocused: (() -> Void)
    
    var body: some View {
        PosterView(
            imageURL: imagePath!,
            width: size.width,
            height: size.height
        )
        .frame(width: size.width, height: size.height)
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
        .onChange(of: isFocused, performAction: { _, _ in
            if self.isFocused { ifFocused() }
        })
        .focused($isFocused)
        //.border(.white)
    }
}


//struct CardItem: View {
//    @FocusState var isFocused: Bool
//
//    var title: String
//    var imagePath: String?
//    let ifPressed: () -> Void
//    let ifFocused: () -> Void
//    let size: CGSize = .init(width: 256, height: 310)
//
//    var body: some View {
//        Button(action: ifPressed, label: {
//            VStack {
//                KFImage.url(URL(string: imagePath ?? ""))
//                    .resizable()
//                    .placeholder({ Image("cardPlaceholder") })
//                    .fade(duration: 0.25)
//                    .clipShape(RoundedRectangle(cornerRadius: 5))
//                    .frame(width: size.width, height: size.height)
////                    .overlay {
////                        RoundedRectangle(cornerRadius: 5)
////                            .inset(by: -10)
////                            .stroke(lineWidth: 4)
////                            .fill(isFocused ? .white : .clear)
////                    }
//            }
//        })
//        .onChange(of: isFocused, initial: false, {
//            if self.isFocused { ifFocused() }
//        })
//        .buttonStyle(TvButtonStyle(focusAnimation: nil))
//        .focused($isFocused)
//        //.buttonStyle(.card)
//        .padding(.vertical, 30)
//        .padding(.horizontal, 10)
//    }
//}
