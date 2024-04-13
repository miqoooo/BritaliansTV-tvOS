//
//  PopupView.swift
//  DemoApp
//
//  Created by miqo on 11.09.23.
//

import SwiftUI

struct PopupView: View {
    @Binding private var popupPresented: Bool
    @FocusState private var focus: Int?
    
    private var message: String
    private var onYes: () -> Void
    
    private var onYesPlaceholder: String
    private var onNoPlaceholder: String
    
    init(
        isPresented: Binding<Bool>,
        message: String,
        onYesPlaceholder: String,
        onNoPlaceholder: String,
        onYes: @escaping () -> Void
    ) {
        self._popupPresented = isPresented
        self.message = message
        self.onYes = onYes
        self.onYesPlaceholder = onYesPlaceholder
        self.onNoPlaceholder = onNoPlaceholder
    }

    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .center, spacing: 10, content: {
                Text(message)
                    .lineLimit(1)
                    .font(.raleway(size: 37, weight: .heavy))
                    .padding(.bottom, 20)
                
                Rectangle()
                    .frame(maxHeight: 10)
                    .foregroundStyle(.white)
                
                HStack(spacing: 10) {
                    Button(action: onYes, label: {
                        Text(onYesPlaceholder.uppercased())
                            .font(.raleway(size: 26, weight: .bold))
                            .padding(20)
                            .frame(width: 175, height: 90)
                    })
                    .focused($focus, equals: 2)
                    .background(focus == 2 ? Color(hex: "#2A1E36") : .clear)
                    .buttonStyle(TvButtonStyle(border: 0))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Button(action: { popupPresented = false }, label: {
                        Text(onNoPlaceholder.uppercased())
                            .font(.raleway(size: 26, weight: .bold))
                            .frame(width: 175, height: 90)
                    })
                    .focused($focus, equals: 1)
                    .background(focus == 1 ? Color(hex: "#2A1E36") : .clear)
                    .buttonStyle(TvButtonStyle(border: 0))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            })
            .padding(.vertical, 40)
            .padding(.top, 30)
            .padding(.horizontal, 30)
            .background(.black)
            .fixedSize()
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .ignoresSafeArea(.all)
    }
}
