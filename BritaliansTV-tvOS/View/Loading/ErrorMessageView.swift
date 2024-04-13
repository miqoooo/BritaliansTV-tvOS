//
//  ErrorMessageView.swift
//  BritaliansTV-tvOS
//
//  Created by miqo on 25.02.24.
//

import SwiftUI

struct ErrorMessageView: View {
    @Binding var isPresented: Bool
    var data: MessageDataModel
    
    var body: some View {
        VStack {
            Text(data.message)
                .font(.raleway(size: 25, weight: .bold))
                .foregroundStyle(data.isError ? Color(hex: "#ff3333") : .green)
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
        }
        .frame(maxWidth: 300)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 30))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                isPresented = false
            })
        }
    }
}
