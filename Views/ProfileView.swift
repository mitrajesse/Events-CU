import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var name = "" // For creating an account
    @State private var isLoggedIn = Auth.auth().currentUser != nil
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isCreatingAccount = false // Toggle between Sign In and Create Account
    @State private var showResendButton = false

    var body: some View {
        ZStack {
            Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // Hex #003865
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(isLoggedIn ? "Welcome Back!" : isCreatingAccount ? "Create Account" : "Sign In")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))) // Hex #fcb716
                    .padding()

                if isLoggedIn {
                    Text("Logged in as \(Auth.auth().currentUser?.email ?? "Unknown")")
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    Button(action: signOut) {
                        Text("Sign Out")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        confirmDeleteAccount()
                    }) {
                        Text("Delete Account")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    VStack(spacing: 15) {
                        if isCreatingAccount {
                            TextField("Name", text: $name)
                                .autocapitalization(.words)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                        }

                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)

                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                            .textContentType(.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)

                        Button(action: isCreatingAccount ? createAccount : login) {
                            Text(isCreatingAccount ? "Create Account" : "Sign In")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }

                        Button(action: { isCreatingAccount.toggle() }) {
                            Text(isCreatingAccount ? "Already have an account? Sign In" : "Don't have an account? Create one")
                                .foregroundColor(.white)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .onAppear {
                checkLoginState()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Account"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func checkLoginState() {
        if let currentUser = Auth.auth().currentUser {
            isLoggedIn = true
            email = currentUser.email ?? ""
        } else {
            isLoggedIn = false
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.alertMessage = "Signed out successfully!"
            self.showAlert = true
        } catch {
            self.alertMessage = "Sign out failed: \(error.localizedDescription)"
            self.showAlert = true
        }
    }

    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertMessage = "Login failed: \(error.localizedDescription)"
                self.showAlert = true
                return
            }

            guard let user = result?.user else {
                self.alertMessage = "Unexpected error occurred. Please try again."
                self.showAlert = true
                return
            }

            if !user.isEmailVerified {
                self.alertMessage = "Email not verified. Please check your inbox and verify your email before logging in."
                self.showAlert = true
                try? Auth.auth().signOut()
                return
            }

            self.isLoggedIn = true
            self.alertMessage = "Logged in successfully!"
            self.showAlert = true
        }
    }

    private func createAccount() {
        guard !name.isEmpty else {
            self.alertMessage = "Please enter your name."
            self.showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertMessage = "Account creation failed: \(error.localizedDescription)"
                self.showAlert = true
                return
            }

            guard let user = result?.user else {
                self.alertMessage = "Failed to create account."
                self.showAlert = true
                return
            }

            // Send verification email
            user.sendEmailVerification { error in
                if let error = error {
                    self.alertMessage = "Failed to send verification email: \(error.localizedDescription)"
                    self.showAlert = true
                } else {
                    self.alertMessage = "Account created! A verification email has been sent. Please verify your email before logging in."
                    self.showAlert = true
                }
            }

            // Save user data in Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "createdAt": Timestamp(date: Date())
            ]

            db.collection("Users").document(user.uid).setData(userData) { error in
                if let error = error {
                    self.alertMessage = "Failed to save user data: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }

            // Immediately log out the user after account creation
            do {
                try Auth.auth().signOut()
            } catch {
                self.alertMessage = "Failed to log out after account creation. Please restart the app."
                self.showAlert = true
            }
        }
    }

    private func confirmDeleteAccount() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            deleteAccount()
        }))

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }

    private func deleteAccount() {
        UserViewModel().deleteAccount { success, error in
            if success {
                self.alertMessage = "Account deleted successfully."
                self.isLoggedIn = false
            } else {
                self.alertMessage = "Failed to delete account: \(error ?? "Unknown error")."
            }
            self.showAlert = true
        }
    }
}
