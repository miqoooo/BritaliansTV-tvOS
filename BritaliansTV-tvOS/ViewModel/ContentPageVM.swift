//
//  ContentPageVM.swift
//  BritaliansTV
//
//  Created by miqo on 08.11.23.
//

import SwiftUI

class ContentPageVM: ObservableObject {
    @Published var currentItem: ItemModel? = nil
    @Published var selectedSeason: ItemModel? = nil
    @Published var selectedSeasonItem: ItemModel? = nil
    @Published var selectedVideo: ItemModel? = nil
    
    @Published var videoItem: ItemModel? = nil
    
    @Published var seasonPresented: Bool = false
    @Published var videoPresented: Bool = false
    
    @Published var trailerURL: String? = nil
}

