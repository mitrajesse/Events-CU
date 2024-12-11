//
//  Events_CUApp.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Events_CUApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var eventsViewModel = EventsViewModel()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .environmentObject(userViewModel)
              .environmentObject(eventsViewModel)
      }
    }
  }
}
