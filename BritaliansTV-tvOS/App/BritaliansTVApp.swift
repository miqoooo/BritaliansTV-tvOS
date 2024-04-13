//
//  BritaliansTVApp.swift
//  BritaliansTV
//
//  Created by miqo on 06.11.23.
//

import SwiftUI
import AVKit

@main
struct BritaliansTVApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var contentVM = ContentPageVM()
    @StateObject var mainPageVM = MainPageVM()
    @StateObject var appVM = ApplicationVM()
    @StateObject var playerVM = PlayerVM()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                    .ignoresSafeArea(.all)
                
                if networkMonitor.isConnected {
                    MessageSection()
                    
                    BackgroundView()
                        .opacity(mainPageVM.loading ? 0 : 1)
                        .focusable(false)
                    
                    NavigationStack {
                        ZStack {
                            MainPage()
                                .opacity(appVM.dataLoaded ? 1 : 0)
                            
                            SplashScreen()
                                .opacity(appVM.dataLoaded ? 0 : 1)
                        }
                        .animation(.default, value: appVM.dataLoaded)
                        .ignoresSafeArea(.all)
                        .environmentObject(playerVM)
                        .environmentObject(mainPageVM)
                        .environmentObject(networkMonitor)
                    }
                    
                } else {
                    if #available(tvOS 17.0, *) {
                        ContentUnavailableView(
                            "No Internet Connection",
                            systemImage: "wifi.exclamationmark",
                            description: Text("Please check your connection and try again.")
                        )
                    } else {
                        Text("No Internet Connection")
                    }
                }
            }
            .fullScreenCover(
                isPresented: $appVM.exitPresented,
                onDismiss: { appVM.exitPresented = false },
                content: PopupContent
            )
            .environmentObject(appVM)
            .environmentObject(contentVM)
        }
    }
    
    @ViewBuilder
    func SplashScreen() -> some View {
        VStack(alignment: .center) {
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
        }
    }
    
    @ViewBuilder
    func MessageSection() -> some View {
        ZStack {
            if mainPageVM.messagePresented {
                ErrorMessageView(
                    isPresented: $mainPageVM.messagePresented,
                    data: mainPageVM.messageData
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(30)
            }
        }
        .animation(.easeInOut, value: mainPageVM.messagePresented)
        .transition(.opacity)
    }
    
    @ViewBuilder
    func PopupContent() -> some View {
        PopupView(
            isPresented: $appVM.exitPresented,
            message: ("Are you sure you want to exit the app?"),
            onYesPlaceholder: ("yes"),
            onNoPlaceholder: ("no"),
            onYes: { exit(0) })
    }
}
