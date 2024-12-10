


import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User {
    var id: String
    var name: String
    var email: String

    private static let db = Firestore.firestore()

    // MARK: - Fetch User by ID
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

    // MARK: - Save User Data
    func save(completion: @escaping (Bool, String?) -> Void) {
        let userData: [String: Any] = [
            "name": self.name,
            "email": self.email
        ]

        User.db.collection("Users").document(self.id).setData(userData, merge: true) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
