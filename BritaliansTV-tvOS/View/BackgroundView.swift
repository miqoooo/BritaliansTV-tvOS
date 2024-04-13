//
//  BackgroundView.swift
//  BritaliansTV
//
//  Created by miqo on 08.11.23.
//

import AVKit
import SwiftUI
import Kingfisher

class BackgroundVM: ObservableObject {
    @Published var startPlayer: Bool = false
    var currentPlayerItem: AVPlayerItem?
    var currentItemURL: String?
}

struct BackgroundView: View {
    @EnvironmentObject var contentVM: ContentPageVM
    @StateObject var backgroundVM = BackgroundVM()
    
    @State var player: AVPlayer = AVPlayer()
    @State var playerItem: AVPlayerItem?
    @State var showPlayer: Bool = false
    
    var imagePath: String {
        if let currentItem = contentVM.currentItem {
            return currentItem.backdrop
        }
        
        return ""
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing, content: {
            KFImage(URL(string: imagePath))
                .onFailureImage(UIImage(named: "backgroundImage"))
                .resizable()
                .frame(width: 1920, height: 1080)
            
            ZStack {
                if let _ = playerItem {
                    TrailerPlayerViewRepresentable(
                        player: player,
                        onLoaded: { showPlayer = true },
                        onEnd: { contentVM.trailerURL = nil }
                    )
                }
            }
            .onReceive(contentVM.$trailerURL, perform: { url in
                if backgroundVM.currentItemURL != url {
                    print("url: [\(url ?? "empty")]")
                    backgroundVM.currentItemURL = url
                    stopPlayer()
                    
                    if let url = url {
                        initTrailer(url: URL(string: url)!)
                    }
                }
            })
            .onDisappear {
                print("[BackgroundView | onDisappear]")
                stopPlayer()
            }
            .opacity(showPlayer ? 1 : 0)
            
            LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom).zIndex(0)
            LinearGradient(colors: [.clear, .clear, .black], startPoint: .center, endPoint: .leading).zIndex(0)
        })
        .onReceive(backgroundVM.$startPlayer.debounce(for: 3, scheduler: RunLoop.main), perform: startPlayer)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .scaleEffect(0.6, anchor: .topTrailing)
        .animation(.spring(duration: 1).speed(2), value: imagePath)
    }
    
    func startPlayer(start: Bool) {
        guard start else { return }
        print("[BackgroundView | startPlayer]")
        
        self.playerItem = backgroundVM.currentPlayerItem
        self.player.replaceCurrentItem(with: self.playerItem)
        self.player.play()
    }
    
    func initTrailer(url: URL) {
        print("[BackgroundView | initTrailer]")
        Task {
            backgroundVM.currentPlayerItem = AVPlayerItem(url: url)
            DispatchQueue.main.async { @MainActor in
                backgroundVM.startPlayer = true
            }
        }
    }
    
    func stopPlayer() {
        print("[BackgroundView | stopPlayer]")
        backgroundVM.startPlayer = false
        if self.playerItem != nil {
            showPlayer = false
            self.player.pause()
            self.player.replaceCurrentItem(with: nil)
            self.playerItem = nil
        }
    }
}
