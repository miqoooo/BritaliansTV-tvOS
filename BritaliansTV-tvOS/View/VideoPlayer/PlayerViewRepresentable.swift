//
//  PlayerViewRepresentable.swift
//  BritaliansTV
//
//  Created by miqo on 12.11.23.
//

import UIKit
import AVKit
import SwiftUI
import GoogleInteractiveMediaAds
import Combine

import AppTrackingTransparency
import AdSupport

struct PlayerViewRepresentabl: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIKitVideoPlayerViewController
    
    var player: AVPlayer
    var playerItem: AVPlayerItem?
    var adData: AdModel
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.player = player
        viewController.playerItem = playerItem
        viewController.adData = adData
        //context.coordinator.startObserver()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewControllerType, coordinator: Coordinator) {
    }
}


class UIKitVideoPlayerViewController: UIViewController, IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    private var playerViewController: AVPlayerViewController!
    
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    
    var player: AVPlayer!
    var playerItem: AVPlayerItem?
    var adData: AdModel!

    var backupPlayerItem: AVPlayerItem!
    
    var backupTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var remainingTime = 0
    var backupObserver: Any?
    var backupStatusObserver: Any?
    var cancellables: Set<AnyCancellable> = []
    
    var skipButton: UIButton!
    var preferredFocusView: UIView?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        if let observer = backupObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        backupTimer.upstream.connect().cancel()
        cancellables.forEach({ $0.cancel() })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black;
        setUpContentPlayer()
        setUpBackupView()
        setUpAdsLoader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        preferredFocusView = playerViewController.view
        
        if let _ = adData.ad_url {
            requestAds()
        } else if let _ = adData.video_url {
            setUpBackupVideo()
        } else {
            playerViewController.player?.play()
        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [preferredFocusView!]
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let _ = context.nextFocusedItem else {
            return
        }
    
        if skipButton?.isHidden == false {
            coordinator.addCoordinatedAnimations({
                self.skipButton?.becomeFirstResponder()
            }, completion: nil)
        } else {
            coordinator.addCoordinatedAnimations({
                self.playerViewController.view.becomeFirstResponder()
            }, completion: nil)
        }
        
        self.setNeedsFocusUpdate()
        //self.updateFocusIfNeeded()
    }
        
    func setUpContentPlayer() {
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        player.replaceCurrentItem(with: playerItem)
        
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)
        showContentPlayer()
    }
    
    func showContentPlayer() {
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.view.frame = self.view.bounds
        
        playerViewController.didMove(toParent:self)
    }
    
    func hideContentPlayer() {
        playerViewController.willMove(toParent:nil)
        playerViewController.view.removeFromSuperview()
        playerViewController.removeFromParent()
    }
    
    func setUpBackupView() {
        skipButton = UIButton(type: .system)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.backgroundColor = .white
        skipButton.tintColor = .black
        skipButton.layer.cornerRadius = 8
        skipButton.addTarget(self, action: #selector(closeBackupPlayer), for: .primaryActionTriggered)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.isHidden = true
        
        if let contentView = playerViewController.contentOverlayView {
            contentView.addSubview(skipButton)
            NSLayoutConstraint.activate([
                skipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
                skipButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
                skipButton.widthAnchor.constraint(equalToConstant: 250)
            ])
        }
    }
    
    func setUpBackupVideo() {
        if let backupURL = URL(string: self.adData.video_url!) {
            self.backupPlayerItem = AVPlayerItem(url: backupURL)
            
            backupTimer
                .sink { [weak self] _ in
                    self?.updateTimer()
                }
                .store(in: &cancellables)
            
            playBackupItem()
        }
    }
    
    func updateTimer() {
        if player?.rate == 1.0 {
            remainingTime -= 1
            if remainingTime <= 0 {
                playBackupItem()
            }
        } else {
            print("Player is paused. \(remainingTime)")
        }
    }
    
    @objc
    func playBackupItem() {
        if player.currentItem != backupPlayerItem {
            print("[UIKitVideoPlayerViewController | playBackupItem] ad Iterval: \(adData.ad_interval!)")
            playerViewController.showsPlaybackControls = false
            
            player.replaceCurrentItem(with: backupPlayerItem)
            player.seek(to: .zero)
            player.play()
            
            backupObserver = NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: backupPlayerItem,
                queue: nil
            ) { [weak self] _ in
                guard let self = self else { return }
                self.closeBackupPlayer()
            }
            
            backupStatusObserver = player.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
                guard let self = self else { return }

                if time.seconds > 0 {
                    self.skipButton.isHidden = false
                    self.preferredFocusView = self.skipButton
                    self.setNeedsFocusUpdate()
                    self.updateFocusIfNeeded()
                }
            }
            
        }
    }
    
    @objc
    func closeBackupPlayer() {
        print("[UIKitVideoPlayerViewController | closeBackupPlayer]")
        player.removeTimeObserver(backupStatusObserver!)
        backupStatusObserver = nil
        
        player.pause()
        player.seek(to: .zero)
        
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        skipButton.isHidden = true
        playerViewController.showsPlaybackControls = true
        remainingTime = /*adData.ad_interval! * 60*/ 60
        
        preferredFocusView = playerViewController.view
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
    }
    
    func setUpAdsLoader() {
        let settings = IMASettings()
        settings.enableBackgroundPlayback = true
        settings.autoPlayAdBreaks = true
        
        adsLoader = IMAAdsLoader(settings: settings)
        adsLoader.delegate = self
    }
    
    func requestAds() {
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
        let request = IMAAdsRequest(
            adTagUrl: adData.ad_url!,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            self.adsLoader.requestAds(with: request)
        })
    }

    func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        adsManager.initialize(with: nil)
        
        print("adCuePoints: \(adsManager.adCuePoints)")
        print("adPlaybackInfo: \(adsManager.adPlaybackInfo)")
    }
    
    func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        print("Error loading ads: " + (adErrorData.adError.message ?? " _ "))
        showContentPlayer()
        playerViewController.player?.play()
    }

    func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
        print("AdsManager error: " + (error.message ?? " _ "))
        showContentPlayer()
        playerViewController.player?.play()
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
        playerViewController.player?.pause()
        hideContentPlayer()
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        showContentPlayer()
        playerViewController.player?.play()
    }
    
    func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        print("adsManager Event type: \(event.typeString)")
        
        if event.type == IMAAdEventType.LOADED {
            adsManager.start()
        }
    }
}
