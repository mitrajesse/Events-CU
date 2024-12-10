import SwiftUI
import FirebaseAuth
import Observation

@Observable
class UserViewModel: ObservableObject {
    var currentUser: User?
    var isLoggedIn: Bool = Auth.auth().currentUser != nil

    // MARK: - Fetch User Details
    func fetchCurrentUser() {
        guard let user = Auth.auth().currentUser else {
            self.currentUser = nil
            return
        }

        User.fetchUser(by: user.uid) { fetchedUser in
            self.currentUser = fetchedUser
        }
    }

    // MARK: - Save User Name
    func updateUserName(_ name: String, completion: @escaping (Bool, String?) -> Void) {
        guard var user = currentUser else {
            completion(false, "No user to update.")
            return
        }

        user.name = name
        user.save { success, error in
            if success {
                self.currentUser = user
            }
            completion(success, error)
        }
    }

    // MARK: - Log In User
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            self.isLoggedIn = true
            self.fetchCurrentUser()
            completion(true, nil)
        }
    }

    // MARK: - Create User Account
    func createAccount(email: String, password: String, name: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                completion(false, "Failed to create user.")
                return
            }

            let newUser = User(id: user.uid, name: name, email: email)
            newUser.save { success, error in
                if success {
                    self.currentUser = newUser
                    self.isLoggedIn = true
                }
                completion(success, error)
            }
        }
    }

    // MARK: - Log Out User
    func logout(completion: @escaping (Bool, String?) -> Void) {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.currentUser = nil
            completion(true, nil)
        } catch {
            completion(false, error.localizedDescription)
        }
    }
}
