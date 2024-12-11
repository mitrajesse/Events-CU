//
//  UserViewModel.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI
import FirebaseAuth
import Observation

@Observable
class UserViewModel: ObservableObject {
    var currentUser: User?
    var isLoggedIn: Bool = Auth.auth().currentUser != nil

    func fetchCurrentUser() {
        guard let user = Auth.auth().currentUser else {
            self.currentUser = nil
            return
        }

        User.fetchUser(by: user.uid) { fetchedUser in
            self.currentUser = fetchedUser
        }
    }

    func deleteAccount(completion: @escaping (Bool, String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "No user logged in.")
            return
        }

        User.deleteUserData(userId: currentUser.uid) { success, error in
            if !success {
                completion(false, error)
                return
            }

            currentUser.delete { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    self.isLoggedIn = false
                    self.currentUser = nil
                    completion(true, nil)
                }
            }
        }
    }
}
