//
//  PageContentView.swift
//  BritaliansTV
//
//  Created by miqo on 11.11.23.
//

import SwiftUI


struct MainPageContent: View {
    @EnvironmentObject var mainPageVM: MainPageVM
    @EnvironmentObject var contentVM: ContentPageVM
    @EnvironmentObject var menuVM: MenuVM
    
    var focus: FocusState<MainPage.FocusFields?>.Binding
    
    var body: some View {
        if let _ = mainPageVM.data, !mainPageVM.loading {
            VStack(alignment: .leading, spacing: 10) {
                Image("appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 30)
                
                HighlightedView(currentItem: contentVM.currentItem)
                    .frame(width: 600, height: 400, alignment: .topLeading)
                
                collectionContentSection()
            }
            .padding(.top, 60)
            .foregroundStyle(.white, Color(hex: "#fff"))
        }
    }
    
    func textColor(_ rowIndex: Int) -> Color {
        switch focus.wrappedValue {
        case .collection(let row, _):
            return row == rowIndex ? .white : .gray
        default: return .gray
        }
    }
    
    @ViewBuilder
    func collectionContentSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            List(Array(mainPageVM.rowData.enumerated()), id: \.offset, rowContent: { (rowIndex, row) in
                LazyVStack {
                    HStack {
                        Text(row.title ?? "")
                            .font(.raleway(size: 35, weight: .semibold))
                            .foregroundStyle(textColor(rowIndex))
                            .padding(.leading, 20)
                        Spacer()
                    }
                    
                    if let items = row.items {
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(Array(items.enumerated()), id:\.offset) { (colIndex, item) in
                                    CardItem(
                                        title: item.title,
                                        imagePath: item.poster,
                                        ifPressed: {
                                            if item.isVideo {
                                                contentVM.selectedVideo = item
                                            } else if item.isSeries || item.isList {
                                                contentVM.selectedSeason = item
                                            }
                                        }, ifFocused: {
                                            print("[MainPageContent | FocusItem]")
                                            contentVM.currentItem = item
                                            contentVM.trailerURL = item.trailerURL
                                        })
                                    .focused(focus, equals: .collection(rowIndex, colIndex))
                                }
                            }
                            .padding(.vertical, 5)
                            //.padding(.leading, 30)
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
