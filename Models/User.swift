//
//  User.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User {
    var id: String
    var name: String
    var email: String

    private static let db = Firestore.firestore()

    static func fetchUser(by id: String, completion: @escaping (User?) -> Void) {
        let userDoc = db.collection("Users").document(id)
        userDoc.getDocument { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists,
                  let data = snapshot.data(),
                  let name = data["name"] as? String,
                  let email = data["email"] as? String else {
                completion(nil)
                return
            }
            let user = User(id: id, name: name, email: email)
            completion(user)
        }
    }

    static func deleteUserData(userId: String, completion: @escaping (Bool, String?) -> Void) {
        db.collection("Users").document(userId).delete { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
