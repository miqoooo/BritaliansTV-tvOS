//
//  ApplicationVM.swift
//  BritaliansTV
//
//  Created by miqo on 11.11.23.
//

import SwiftUI

class ApplicationVM: ObservableObject {
    @Published var dataLoaded: Bool = false
    @Published var exitPresented: Bool = false
}
