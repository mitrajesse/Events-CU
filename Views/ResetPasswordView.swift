import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer() // Push content higher
                    
                    Text("Reset Password")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                        .padding(.bottom, 20) // Add some bottom padding
                    
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
                    
                    Spacer(minLength: 462.5) // Add some spacing at the bottom
                }
                .padding()
            }
        }
    }
}
