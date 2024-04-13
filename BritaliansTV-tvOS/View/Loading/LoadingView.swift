//
//  LoadingView.swift
//  BritaliansTV
//
//  Created by miqo on 11.11.23.
//

import SwiftUI
import Combine

struct LoadingView: View {
    @State private var isRotating: Bool = false
    private var frame: CGSize
    private var radius: CGFloat
    
    var loading: Bool
    
    init(loading: Bool, radius: CGFloat = 5, frame: CGSize = CGSize(width: 90, height: 90)) {
        self.loading = loading
        
        self.frame = frame
        self.radius = radius
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Circle()
                    .inset(by: radius/2)
                    .stroke(lineWidth: radius)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [
                            Color(hex: "#fff"),
                            Color(hex: "#3688FF"),
                            Color(hex: "#3688FF"),
                            Color(hex: "#fff"),
                        ]), startPoint: .leading, endPoint: .trailing)
                    )
                    .rotationEffect(isRotating ? .degrees(360) : .zero)
                    .frame(width: frame.width, height: frame.height, alignment: .center)
                    .onChange(of: loading, performAction: { _, loading in
                        if loading {
                            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                self.isRotating = true
                            }
                        }
                    })
                Spacer()
            }
            Spacer()
        }
    }
}
