import SwiftUI

struct ContentView: View {
    // Constants for reused colors
    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)) // #fcb716
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // #003865
    
    @State private var selectedTab: Int = 0 // Track selected tab
    
    init() {
        // Set TabView appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(barBackgroundColor) // Set a consistent background color
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black // Unselected icon color
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white // Selected icon color
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14) // Larger, bold text for unselected state
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14) // Larger, bold text for selected state
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance // Apply to the scrollable edge as well
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home View
            NavigationStack {
                HomeView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("Home")
                }
            }
            .tag(0) // Assign a tag to track this tab
            
            // On Campus View
            NavigationStack {
                OnCampusView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "building.columns.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("On Campus")
                }
            }
            .tag(1) // Assign a tag to track this tab
            
            // Off Campus View
            NavigationStack {
                OffCampusView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("Off Campus")
                }
            }
            .tag(2) // Assign a tag to track this tab
            
            // More View
            NavigationStack {
                MoreView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("More")
                }
            }
            .tag(3) // Assign a tag to track this tab
        }
        .background(appBackgroundColor.ignoresSafeArea()) // Background color for the app
    }
}

#Preview {
    ContentView()
}
