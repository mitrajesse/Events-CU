import SwiftUI

struct HomeView: View {
    @State private var userViewModel = UserViewModel() // Create an instance of UserViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))
                    .ignoresSafeArea()
                
                // Welcome Text in the center
                VStack(spacing: 10) {
                    Text("Welcome to")
                        .font(.system(size: 40, weight: .bold)) // First line
                        .foregroundColor(.white)
                    
                    Text("Events@CU")
                        .font(.system(size: 50, weight: .bold)) // Second line
                        .foregroundColor(.white)
                    
                    // Display the user's name if available, otherwise fallback to "Guest"
                    Text(userViewModel.isLoggedIn ? userViewModel.currentUser?.name ?? "Guest" : "Guest")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(.white) // Text color set to white
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        HStack(spacing: 10) {
                            // Display the username if logged in, otherwise "Sign In"
                            Text(userViewModel.isLoggedIn ? userViewModel.currentUser?.name ?? "Sign In" : "Sign In")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color(red: 252/255, green: 183/255, blue: 22/255)) // Icon color set to FCB716
                        }
                    }
                }
            }
            .onAppear {
                userViewModel.fetchCurrentUser() // Fetch user details when HomeView appears
            }
        }
    }
}

#Preview {
    HomeView()
}
