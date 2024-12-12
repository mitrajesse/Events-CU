//
//  ProfileViewModel.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var isLoggedIn = Auth.auth().currentUser != nil
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var isCreatingAccount = false
    @Published var showResendButton = false
    @Published var displayName = ""
    
    func checkLoginState() {
        if let currentUser = Auth.auth().currentUser {
            isLoggedIn = true
            email = currentUser.email ?? ""
            fetchUserData()
        } else {
            isLoggedIn = false
            displayName = ""
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.name = ""
            self.email = ""
            self.displayName = ""
            self.alertMessage = "Signed out successfully!"
            self.showAlert = true
        } catch {
            self.alertMessage = "Sign out failed: \(error.localizedDescription)"
            self.showAlert = true
        }
    }
    
    func login() {
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
            self.fetchUserData()
            self.alertMessage = "Logged in successfully!"
            self.showAlert = true
        }
    }
    
    func createAccount() {
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
            
            user.sendEmailVerification { error in
                if let error = error {
                    self.alertMessage = "Failed to send verification email: \(error.localizedDescription)"
                    self.showAlert = true
                } else {
                    self.alertMessage = "Account created! A verification email has been sent. Please verify your email before logging in."
                    self.showAlert = true
                }
            }
            
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "name": self.name,
                "email": self.email,
                "createdAt": Timestamp(date: Date())
            ]
            
            db.collection("Users").document(user.uid).setData(userData) { error in
                if let error = error {
                    self.alertMessage = "Failed to save user data: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
            
            do {
                try Auth.auth().signOut()
            } catch {
                self.alertMessage = "Failed to log out after account creation. Please restart the app."
                self.showAlert = true
            }
        }
    }
    
    func fetchUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userDoc = db.collection("Users").document(currentUser.uid)
        
        userDoc.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to fetch user data: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(), let userName = data["name"] as? String {
                DispatchQueue.main.async {
                    self.displayName = userName
                    self.name = userName
                }
            }
        }
    }
    
    func deleteAccount(completion: @escaping (Bool, String?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, "No user logged in")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Users").document(user.uid).delete { error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            user.delete { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}
