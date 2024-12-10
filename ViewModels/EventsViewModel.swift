

import FirebaseFirestore

class EventsViewModel: ObservableObject {
    @Published var onCampusEvents: [Event] = []
    @Published var offCampusEvents: [Event] = []

    func fetchEvents(isOffCampus: Bool, completion: @escaping ([Event]) -> Void) {
        let db = Firestore.firestore()
        db.collection("Events")
            .whereField("isOffCampus", isEqualTo: isOffCampus)
            .order(by: "date")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching events: \(error.localizedDescription)")
                    completion([]) // Return empty array on error
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    completion([]) // Return empty array if no documents
                    return
                }

                // Map Firestore documents to Event objects
                let fetchedEvents = documents.compactMap { doc -> Event? in
                    print("Document data: \(doc.data())") // Debug: Print fetched data
                    return Event(id: doc.documentID, data: doc.data())
                }

                // Update the correct event array on the main thread
                DispatchQueue.main.async {
                    if isOffCampus {
                        self.offCampusEvents = fetchedEvents
                    } else {
                        self.onCampusEvents = fetchedEvents
                    }
                }

                // Return the fetched events to the completion handler
                completion(fetchedEvents)
            }
    }
}
