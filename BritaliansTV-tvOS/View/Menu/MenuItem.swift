//
//  MenuItems.swift
//  DemoApp
//
//  Created by miqo on 11.09.23.
//

import SwiftUI

enum MenuItem: Identifiable, CaseIterable, Hashable {
    case home
    case states
    case humans
    case brands
    case exit
    
    //case none
    
    var id: Int { hashValue }
    
    var name: String {
        switch self {
        case .home: return "Home"
        case .states: return "States"
        case .humans: return "Humans"
        case .brands: return "Brands"
        case .exit: return "Exit"
        //default: return ""
        }
    }
    
    var image: String {
        return self.name.lowercased()
    }
}
