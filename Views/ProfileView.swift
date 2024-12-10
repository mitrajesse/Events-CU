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
                    // Show user info if logged in
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
                } else {
                    VStack(spacing: 15) {
                        if isCreatingAccount {
                            TextField("Name", text: $name) // Name input for account creation
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
                        
                        if showResendButton {
                            Button(action: resendVerificationEmail) {
                                Text("Resend Verification Email")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))) // Hex #fcb716
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Button(action: resetPassword) {
                            Text("Forgot Password?")
                                .foregroundColor(.white)
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
 
    // MARK: - Check Login State
    private func checkLoginState() {
        if let currentUser = Auth.auth().currentUser {
            isLoggedIn = true
            email = currentUser.email ?? ""
        } else {
            isLoggedIn = false
        }
    }
 
    // MARK: - Log In Function
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
 
            // Check if email is verified
            if !user.isEmailVerified {
                self.alertMessage = "Email not verified. Please check your inbox and verify your email before logging in."
                self.showAlert = true
                try? Auth.auth().signOut() // Automatically log them out to prevent session persistence
                return
            }
 
            // Allow login if email is verified
            self.isLoggedIn = true
            self.alertMessage = "Logged in successfully!"
            self.showAlert = true
        }
    }
 
 
    // MARK: - Create Account Function
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
 
            // Send email verification
            user.sendEmailVerification { error in
                if let error = error {
                    self.alertMessage = "Failed to send verification email: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
 
                self.alertMessage = "Account created! A verification email has been sent. Please verify your email before logging in."
                self.showResendButton = true // Show the Resend Verification Email button
                self.showAlert = true
 
                // Immediately sign out the user after sending the verification email
                do {
                    try Auth.auth().signOut()
                } catch {
                    self.alertMessage = "Failed to log out after account creation. Please restart the app."
                    self.showAlert = true
                }
            }
 
            // Save user details in Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "isAdmin": false, // Default value
                "createdAt": Timestamp(date: Date())
            ]
 
            db.collection("Users").document(user.uid).setData(userData) { error in
                if let error = error {
                    self.alertMessage = "Failed to save user data: \(error.localizedDescription)"
                }
            }
        }
    }
 
    // MARK: - Reset Password Function
    private func resetPassword() {
        guard !email.isEmpty else {
            self.alertMessage = "Please enter your email address."
            self.showAlert = true
            return
        }
 
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.alertMessage = "Failed to send reset email: \(error.localizedDescription)"
                self.showAlert = true
                return
            }
 
            self.alertMessage = "Password reset email sent successfully!"
            self.showAlert = true
        }
    }
 
    // MARK: - Sign Out Function
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
    private func resendVerificationEmail() {
        guard let user = Auth.auth().currentUser else {
            self.alertMessage = "No user logged in."
            self.showAlert = true
            return
        }
 
        user.sendEmailVerification { error in
            if let error = error {
                self.alertMessage = "Failed to resend verification email: \(error.localizedDescription)"
            } else {
                self.alertMessage = "Verification email resent successfully!"
            }
            self.showAlert = true
        }
    }
}
 
 
#Preview {
    ProfileView()
}
