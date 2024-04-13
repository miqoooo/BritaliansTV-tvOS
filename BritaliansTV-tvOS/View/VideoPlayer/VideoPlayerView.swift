//
//  VideoPlayerView.swift
//  BritaliansTV
//
//  Created by miqo on 12.11.23.
//

import SwiftUI
import AVKit

class PlayerVM: ObservableObject {
    var player = AVPlayer()
    var currentItem: AVPlayerItem?
    var adData: AdModel? = nil
    
    private var currentURL: URL? = nil
    
    func load(url: URL) {
        if self.currentURL != url {
            Task {
                let asset = AVAsset(url: url)
                self.currentItem = AVPlayerItem(asset: asset)
                self.player.replaceCurrentItem(with: self.currentItem)
                self.currentURL = url
            }
        }
    }
    
    func reset() {
        self.player.pause()
        self.player.replaceCurrentItem(with: nil)
    }
}

struct VideoPlayerView: View {
    @EnvironmentObject var playerVM: PlayerVM
    
    var body: some View {
        PlayerViewRepresentabl(
            player: playerVM.player,
            playerItem: playerVM.currentItem,
            adData: playerVM.adData!
        ) 
        .ignoresSafeArea()
    }
}


/*
 //struct PlayerViewRepresentabl: UIViewControllerRepresentable {
 //    var player: AVPlayer
 //    var adData: AdModel!
 //
 //    func makeUIViewController(context: Context) -> UIKitVideoPlayerViewController {
 //        let viewController = UIKitVideoPlayerViewController()
 //        viewController.player = player
 //        viewController.adData = adData
 //        return viewController
 //    }
 //
 //    func updateUIViewController(_ uiViewController: UIKitVideoPlayerViewController, context: Context) {
 //    }
 //
 //    static func dismantleUIViewController(_ uiViewController: UIKitVideoPlayerViewController, coordinator: Coordinator) {
 //    }
 //}
 //
 //class UIKitVideoPlayerViewController: UIViewController {
 //    private var playerViewController: AVPlayerViewController!
 //
 //    var adsLoader: IMAAdsLoader!
 //    var adsManager: IMAAdsManager!
 //    var contentPlayhead: IMAAVPlayerContentPlayhead?
 //
 //    var player: AVPlayer!
 //    var playerItem: AVPlayerItem!
 //    var backupPlayerItem: AVPlayerItem!
 //    var adData: AdModel!
 //
 //    var backupTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 //    var remainingTime = 0
 //    var backupObserver: Any?
 //    var backupStatusObserver: NSKeyValueObservation?
 //    var cancellables: Set<AnyCancellable> = []
 //
 //    var skipButton: UIButton!
 //    var preferredFocusView: UIView?
 //
 //    deinit {
 //        NotificationCenter.default.removeObserver(self)
 //
 //        if let observer = backupObserver {
 //            NotificationCenter.default.removeObserver(observer)
 //        }
 //
 //        backupTimer.upstream.connect().cancel()
 //        cancellables.forEach({ $0.cancel() })
 //    }
 //
 //    override func viewDidLoad() {
 //        super.viewDidLoad()
 //        self.view.backgroundColor = UIColor.black;
 //
 //        setUpContentPlayer()
 //        setUpBackupView()
 //        setUpAdsLoader()
 //    }
 //
 //    override func viewDidAppear(_ animated: Bool) {
 //        super.viewDidAppear(animated);
 //        self.playerItem = player.currentItem!
 //
 //        if let _ = adData?.ad_url {
 //            requestAds()
 //        } else if let _ = adData?.video_url {
 //            setUpBackupVideo()
 //        } else {
 //            playerViewController.player?.play()
 //        }
 //    }
 //
 //    func setUpContentPlayer() {
 //        playerViewController = AVPlayerViewController()
 //        playerViewController.player = player
 //
 //        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)
 //        showContentPlayer()
 //    }
 //
 //    func showContentPlayer() {
 //        self.addChild(playerViewController)
 //        playerViewController.view.frame = self.view.bounds
 //        self.view.insertSubview(playerViewController.view, at: 0)
 //        playerViewController.didMove(toParent:self)
 //
 //        playerViewController.view.translatesAutoresizingMaskIntoConstraints = true
 //        playerViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
 //        playerViewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
 //        playerViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
 //        playerViewController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
 //    }
 //
 //    func hideContentPlayer() {
 //        playerViewController.willMove(toParent: nil)
 //        playerViewController.view.removeFromSuperview()
 //        playerViewController.removeFromParent()
 //    }
 //
 //    func setUpBackupView() {
 //        skipButton = UIButton(type: .system)
 //        skipButton.setTitle("Skip", for: .normal)
 //        skipButton.backgroundColor = .white
 //        skipButton.tintColor = .black
 //        skipButton.layer.cornerRadius = 8
 //        skipButton.addTarget(self, action: #selector(closeBackupPlayer), for: .primaryActionTriggered)
 //        skipButton.translatesAutoresizingMaskIntoConstraints = false
 //        skipButton.isHidden = true
 //
 //        skipButton.isUserInteractionEnabled = true
 //
 //        if let contentView = self.view {
 //            contentView.addSubview(skipButton)
 //            NSLayoutConstraint.activate([
 //                skipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
 //                skipButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
 //                skipButton.widthAnchor.constraint(equalToConstant: 300)
 //            ])
 //        }
 //    }
 //
 //    override var preferredFocusEnvironments: [UIFocusEnvironment] {
 //        return [preferredFocusView!]
 //    }
 //
 //    func setUpBackupVideo() {
 //        if let video_url = adData?.video_url,
 //           let backupURL = URL(string: "https://file-examples.com/storage/fe5f588707659e1c5986414/2017/04/file_example_MP4_480_1_5MG.mp4"/*video_url*/) {
 //            self.backupPlayerItem = AVPlayerItem(url: backupURL)
 //
 //            print("ad Iterval: \(adData?.ad_interval ?? 0)")
 //            print("backupPlayerItem: \(self.backupPlayerItem.status)")
 //
 //            backupTimer
 //                .sink { [weak self] _ in
 //                    self?.updateTimer()
 //                }
 //                .store(in: &cancellables)
 //
 //            playBackupItem()
 //        }
 //    }
 //
 //    @objc
 //    func playBackupItem() {
 //        if player.currentItem != backupPlayerItem {
 //            playerViewController.showsPlaybackControls = false
 //
 //            print("playng backup Item \(adData!.video_url!)")
 //
 //            player.pause()
 //            player.replaceCurrentItem(with: backupPlayerItem)
 //            player.seek(to: .zero)
 //
 //            player.play()
 //            playerViewController.view.isUserInteractionEnabled = false
 //
 //            skipButton.isHidden = false
 //            preferredFocusView = skipButton
 //            setNeedsFocusUpdate()
 //            updateFocusIfNeeded()
 //
 //            backupObserver = NotificationCenter.default.addObserver(
 //                forName: .AVPlayerItemDidPlayToEndTime,
 //                object: backupPlayerItem,
 //                queue: nil
 //            ) { [weak self] _ in
 //                guard let self = self else { return }
 //                self.closeBackupPlayer()
 //            }
 //        }
 //    }
 //
 //    @objc
 //    func closeBackupPlayer() {
 //        player.replaceCurrentItem(with: playerItem)
 //        player.play()
 //
 //        backupStatusObserver?.invalidate()
 //
 //        skipButton.isHidden = true
 //        playerViewController.view.isUserInteractionEnabled = true
 //        playerViewController.showsPlaybackControls = true
 //
 //        preferredFocusView = playerViewController.view
 //        setNeedsFocusUpdate()
 //        updateFocusIfNeeded()
 //
 //        remainingTime = 60 //adData.ad_interval! * 60
 //    }
 //
 //    func updateTimer() {
 //        if player?.rate == 1.0 {
 //            remainingTime -= 1
 //            if remainingTime <= 0 {
 //                playBackupItem()
 //            }
 //        } else {
 //            print("Player is paused. \(remainingTime)")
 //        }
 //    }
 //
 //    func setUpAdsLoader() {
 //        let settings = IMASettings()
 //        settings.enableBackgroundPlayback = true
 //        settings.autoPlayAdBreaks = true
 //
 //        adsLoader = IMAAdsLoader(settings: settings)
 //        adsLoader.delegate = self
 //    }
 //
 //    func requestAds() {
 //        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
 //        if let adURL = adData?.ad_url {
 //            let request = IMAAdsRequest(
 //                adTagUrl: adURL,
 //                adDisplayContainer: adDisplayContainer,
 //                contentPlayhead: contentPlayhead,
 //                userContext: nil)
 //
 //            adsLoader.requestAds(with: request)
 //        }
 //    }
 //}
 //
 //extension UIKitVideoPlayerViewController: IMAAdsLoaderDelegate {
 //    func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
 //        adsManager = adsLoadedData.adsManager
 //        adsManager.delegate = self
 //        adsManager.initialize(with: nil)
 //
 //        print("adCuePoints: \(adsManager.adCuePoints)")
 //        print("adPlaybackInfo: \(adsManager.adPlaybackInfo)")
 //    }
 //
 //    func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
 //        print("Error loading ads: " + (adErrorData.adError.message ?? " _ "))
 //        showContentPlayer()
 //        playerViewController.player?.play()
 //    }
 //}
 //
 //extension UIKitVideoPlayerViewController: IMAAdsManagerDelegate {
 //    func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
 //        print("AdsManager error: " + (error.message ?? " _ "))
 //        showContentPlayer()
 //        playerViewController.player?.play()
 //    }
 //
 //    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
 //        playerViewController.player?.pause()
 //        hideContentPlayer()
 //    }
 //
 //    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
 //        showContentPlayer()
 //        playerViewController.player?.play()
 //    }
 //
 //    func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
 //        print("adsManager Event type: \(event.typeString)")
 //
 //        if event.type == IMAAdEventType.LOADED {
 //            adsManager.start()
 //        }
 //    }
 //}

 */
