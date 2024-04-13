//
//  MenuVM.swift
//  BritaliansTV
//
//  Created by miqo on 08.11.23.
//

import SwiftUI

class MenuVM: ObservableObject {
    @Published var opened: Bool = false
    @Published var selection: MenuItem = .home
    
    var isFocusable: Bool = false
}
