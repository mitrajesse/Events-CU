import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("Reset Password")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                        .padding(.bottom, 20) // Add some bottom padding for separation
                    
                    TextField("Enter your email", text: $viewModel.resetPasswordEmail)
                        .textFieldStyle(AuthTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .accentColor(.black)
                        .colorScheme(.light)
                    
                    Button(action: {
                        viewModel.resetPassword()
                    }) {
                        Text("Send Reset Email")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    Spacer() // Add space at the bottom
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("") // Removes the navigation bar's title
            .navigationBarHidden(true) // Hides the navigation bar to avoid overlap
        }
    }
}
