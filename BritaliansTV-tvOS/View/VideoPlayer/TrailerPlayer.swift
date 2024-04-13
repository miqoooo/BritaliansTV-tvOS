//
//  TrailerPlayer.swift
//  BritaliansTV-tvOS
//
//  Created by miqo on 20.01.24.
//

import UIKit
import AVKit
import SwiftUI

struct TrailerPlayerViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = AVPlayerViewController
    
    var player: AVPlayer!
    
    var onLoaded: (() -> Void)?
    var onEnd: (() -> Void)?
        
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        
        viewController.player = player
        viewController.showsPlaybackControls = false
        context.coordinator.updateObservers()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.updateObservers()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: TrailerPlayerViewRepresentable
        var currentPlayerItem: AVPlayerItem?
        var isLoaded: Bool = false
        
        init(_ parent: TrailerPlayerViewRepresentable) {
            print("[TrailerPlayerViewRepresentable::Coordinator | Init]")
            self.parent = parent
        }
        
        func updateObservers() {
            guard let currentItem = self.parent.player.currentItem else {
                stopObservers()
                return
            }
            
            if self.parent.player.currentItem != currentPlayerItem {
                stopObservers()
                currentPlayerItem = currentItem
                isLoaded = false
             
                print("[TrailerPlayerViewRepresentable | startObservers]")
                NotificationCenter.default
                    .addObserver(self,
                                 selector: #selector(playerDidFinishPlaying),
                                 name: AVPlayerItem.didPlayToEndTimeNotification,
                                 object: currentPlayerItem
                    )
                
                NotificationCenter.default
                    .addObserver(self,
                                 selector: #selector(playerItemDidReadyToPlay),
                                 name: AVPlayerItem.newAccessLogEntryNotification,
                                 object: currentPlayerItem
                    )
            }
        }
        
        func stopObservers() {
            print("[TrailerPlayerViewRepresentable | stopObservers]")
            NotificationCenter.default
                .removeObserver(self,
                                name: AVPlayerItem.didPlayToEndTimeNotification,
                                object: currentPlayerItem
                )
        
            NotificationCenter.default
                .removeObserver(self,
                                name: AVPlayerItem.newAccessLogEntryNotification,
                                object: currentPlayerItem
                )
        
        }
        
        @objc
        func playerItemDidReadyToPlay(_ aNotification: Notification!) {
            guard let _ = aNotification.object as? AVPlayerItem else { return }
            if isLoaded == false {
                print("Player Ready To Play")
                
                self.parent.onLoaded?()
                self.isLoaded = true
            }
        }
        
        @objc
        func playerDidFinishPlaying(_ aNotification: Notification!) {
            guard let _ = aNotification.object as? AVPlayerItem else { return }
            print("Player Playback Ended")
            self.parent.onEnd?()
        }
    }
}
