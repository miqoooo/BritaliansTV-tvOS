//
//  SeasonContentPage.swift
//  BritaliansTV
//
//  Created by miqo on 11.11.23.
//

import SwiftUI

struct VideoPageContent: View {
    @EnvironmentObject var contentVM: ContentPageVM
    @EnvironmentObject var playerVM: PlayerVM
    
    @Binding var mediaItem: ItemModel?
    @FocusState var focus: String?
    @FocusState var isPlayFocused: Bool
    
    @State var playTrailer: Bool = false
    
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
            
            HStack {
                Button(action: {
                    print("current Item link: ", contentVM.currentItem!.link)
                    
                    contentVM.trailerURL = nil
                    contentVM.videoItem = contentVM.currentItem
                }, label: {
                    Label(title: {
                        Text("Play")
                            .font(.raleway(size: 27, weight: .bold))
                    }, icon: {
                        Image(systemName: "play.fill")
                            .padding(.leading, 20)
                            .imageScale(.large)
                    })
                    .frame(minWidth: 400, minHeight: 60, alignment: .leading)
                    .background(isPlayFocused ? .white : .black)
                    .foregroundStyle(isPlayFocused ? .black : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                })
                .focused($isPlayFocused)
                .buttonStyle(TvButtonStyle(border: 0))
                .padding([.leading, .bottom], 30)
                
                Spacer()
            }
            .focusSection()
            
            if let _ = mediaItem {
                collectionContentSection()
                    .onAppear {
                        contentVM.trailerURL = mediaItem!.trailerURL
                        playerVM.load(url: URL(string: mediaItem!.link)!)
                    }
            }
        }
        //.defaultFocus($focus, "0_0")
        .defaultFocus($isPlayFocused, true)
        .foregroundStyle(.white, Color(hex: "#fff"))
        .onChange(of: isPlayFocused, performAction: { _, newValue in
            if newValue {
                contentVM.currentItem = mediaItem
            }
        })
        .fullScreenCover(
            item: $contentVM.videoItem,
            onDismiss: {
                playerVM.reset()
            },
            content: { item in
                VideoPlayerView()
                    .ignoresSafeArea()
            })
    }
    
    @ViewBuilder
    func collectionContentSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            List(Array(mediaItem!.videoRow.enumerated()), id: \.offset, rowContent: { (rowIndex, row) in
                LazyVStack {
                    HStack {
                        Text(row.title ?? "")
                            .font(.raleway(size: 35, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
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
                                        }, ifFocused: {
                                            print("[VideoPageContent | FocusItem]")
                                            DispatchQueue.main.async {
                                                contentVM.currentItem = item
                                            }
                                        })
                                    .focused($focus, equals: "\(rowIndex)_\(colIndex)")
                                }
                            }
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
