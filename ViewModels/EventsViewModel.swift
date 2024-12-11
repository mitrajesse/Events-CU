//
//  EventsViewModel.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import FirebaseFirestore

class EventsViewModel: ObservableObject {
    @Published var onCampusEvents: [Event] = []
    @Published var offCampusEvents: [Event] = []
    @Published var sortOrder: SortOrder = .dateAscending

    enum SortOrder {
        case dateAscending, dateDescending, nameAscending, nameDescending
    }

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
    var sortedOnCampusEvents: [Event] {
        sortEvents(events: onCampusEvents)
    }
    var sortedOffCampusEvents: [Event] {
        sortEvents(events: offCampusEvents)
    }
    
    private func sortEvents(events: [Event]) -> [Event] {
        switch sortOrder {
        case .dateAscending:
            return events.sorted { $0.date < $1.date }
        case .dateDescending:
            return events.sorted { $0.date > $1.date }
        case .nameAscending:
            return events.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .nameDescending:
            return events.sorted { $0.name.lowercased() > $1.name.lowercased() }
        }
    }
}
