//
//  SeasonContentPage.swift
//  BritaliansTV
//
//  Created by miqo on 11.11.23.
//

import SwiftUI

struct SeasonPageContent: View {
    @EnvironmentObject var playerVM: PlayerVM
    @EnvironmentObject var mainPageVM: MainPageVM
    @EnvironmentObject var contentVM: ContentPageVM
    
    @FocusState var focus: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Image("appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 30)
                
                HighlightedView(currentItem: contentVM.currentItem)
                    .frame(maxWidth: 600, minHeight: 400, maxHeight: 400, alignment: .topLeading)
            }
            .padding(.leading, 30)
            
            if let _ = contentVM.selectedSeason {
                collectionContentSection()
            }
        }
//        .navigationDestination(item: $contentVM.selectedSeasonItem, destination: { _ in
//            VideoPageContent(mediaItem: $contentVM.selectedSeasonItem)
//                .environmentObject(contentVM)
//                .environmentObject(playerVM)
//        })
        .defaultFocus($focus, "0_0")
        .foregroundStyle(.white, Color(hex: "#fff"))
    }
    
    @ViewBuilder
    func collectionContentSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            List(Array(contentVM.selectedSeason!.seasons.enumerated()), id: \.offset, rowContent: { (rowIndex, row) in
                LazyVStack {
                    HStack {
                        Text(row.title ?? "")
                            .font(.raleway(size: 35, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    
                    if let items = row.items {
                        ScrollView(.horizontal) {
                            HStack(spacing: -5) {
                                ForEach(Array(items.enumerated()), id:\.offset) { (colIndex, item) in
                                    CardItem(
                                        title: item.title,
                                        imagePath: item.poster,
                                        ifPressed: {
                                            //print("focused Item: ", item.prettyPrint)
                                            DispatchQueue.main.async {
                                                contentVM.selectedSeasonItem = item
                                            }
                                        }, ifFocused: {
                                            print("[SeasonPageContent | FocusItem]")
                                            DispatchQueue.main.async {
                                                contentVM.currentItem = item
                                                contentVM.trailerURL = item.trailerURL
                                            }
                                        })
                                    .focused($focus, equals: "\(rowIndex)_\(colIndex)")
                                }
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 200)
                            
                            Spacer()
                        }
                        .focusSection()
                    }
                }
            })
        }
    }
}
