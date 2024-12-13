//
//  ProfileView.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack(spacing: 20) {
                headerView
                
                if viewModel.isLoggedIn {
                    loggedInContent
                } else {
                    authenticationContent
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.checkLoginState()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Account"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var backgroundColor: some View {
        Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))
            .ignoresSafeArea()
    }
    
    private var headerView: some View {
        Text(viewModel.isLoggedIn ? "Welcome Back!" :
             viewModel.isCreatingAccount ? "Create Account" : "Sign In")
            .font(.largeTitle)
            .bold()
            .foregroundColor(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
            .padding()
    }
    
    private var loggedInContent: some View {
        VStack {
            Text("Logged in as \(viewModel.email)")
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            signOutButton
            deleteAccountButton
        }
    }
    
    private var signOutButton: some View {
        Button(action: viewModel.signOut) {
            Text("Sign Out")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }
    
    private var deleteAccountButton: some View {
        Button(action: confirmDeleteAccount) {
            Text("Delete Account")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var resendVerificationButton: some View {
        Button(action: viewModel.resendVerificationEmail) {
            Text("Resend Verification Email")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))) // Matches the "Sign In" button background
                .foregroundColor(.black) // Same black font as "Sign In"
                .cornerRadius(10)
        }
    }
    
    private var authenticationContent: some View {
        VStack(spacing: 15) {
            if viewModel.isCreatingAccount {
                nameTextField
            }
            
            emailTextField
            passwordTextField
            authenticationButton
            
            if viewModel.shouldShowResendButton {
                resendVerificationButton
            }
            
            resetPasswordButton
            
            toggleAuthenticationModeButton
        }
    }

    
    
    private var nameTextField: some View {
        TextField("Name", text: $viewModel.name)
            .autocapitalization(.words)
            .textFieldStyle(AuthTextFieldStyle())
            .accentColor(.black)
            .colorScheme(.light)
    }
    
    private var emailTextField: some View {
        TextField("Email", text: $viewModel.email)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .textFieldStyle(AuthTextFieldStyle())
            .accentColor(.black)
            .colorScheme(.light)
    }
    private var resetPasswordButton: some View {
        Button(action: {
            viewModel.showResetPasswordDialog = true
        }) {
            Text("Forgot Password?")
                .foregroundColor(.white)
                .underline()
                .padding(.top, 5)
        }
        .navigationDestination(isPresented: $viewModel.showResetPasswordDialog) {
            ResetPasswordView(viewModel: viewModel)
        }
    }
    
    private var passwordTextField: some View {
        SecureField("Password", text: $viewModel.password)
            .autocapitalization(.none)
            .textContentType(.password)
            .textFieldStyle(AuthTextFieldStyle())
            .accentColor(.black)
            .colorScheme(.light)
    }
    
    private var authenticationButton: some View {
        Button(action: viewModel.isCreatingAccount ? viewModel.createAccount : viewModel.login) {
            Text(viewModel.isCreatingAccount ? "Create Account" : "Sign In")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }
    
    private var toggleAuthenticationModeButton: some View {
        Button(action: { viewModel.isCreatingAccount.toggle() }) {
            Text(viewModel.isCreatingAccount ?
                 "Already have an account? Sign In" :
                 "Don't have an account? Create one")
                .foregroundColor(.white)
        }
    }
    
    private func confirmDeleteAccount() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            viewModel.deleteAccount { success, error in
                if success {
                    viewModel.alertMessage = "Account deleted successfully."
                    viewModel.isLoggedIn = false
                    viewModel.name = ""
                    viewModel.displayName = ""
                } else {
                    viewModel.alertMessage = "Failed to delete account: \(error ?? "Unknown error")."
                }
                viewModel.showAlert = true
            }
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(8)
    }
}
