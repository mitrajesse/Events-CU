//
//  Event.swift
//  Events@CU
//
//  Created by Jesse Mitra on 11/12/24.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable {
    let id: String
    var name: String
    var description: String
    var location: String
    var date: Date
    var isOffCampus: Bool
    var rsvp: [String]
    var organizer: String

    // MARK: - Custom Initializer
    init(id: String, name: String, description: String, location: String, date: Date, isOffCampus: Bool, rsvp: [String], organizer: String) {
        self.id = id
        self.name = name
        self.description = description
        self.location = location
        self.date = date
        self.isOffCampus = isOffCampus
        self.rsvp = rsvp
        self.organizer = organizer
    }

    // MARK: - Initialize from Firestore Document
    init?(id: String, data: [String: Any]) {
        self.id = id
        guard
            let name = data["name"] as? String,
            let description = data["description"] as? String,
            let location = data["location"] as? String,
            let timestamp = data["date"] as? Timestamp,
            let isOffCampus = data["isOffCampus"] as? Bool,
            let rsvp = data["rsvp"] as? [String],
            let organizer = data["organizer"] as? String
        else {
            return nil
        }

        self.name = name
        self.description = description
        self.location = location
        self.date = timestamp.dateValue()
        self.isOffCampus = isOffCampus
        self.rsvp = rsvp
        self.organizer = organizer
    }

    // MARK: - Convert to Dictionary for Saving to Firestore
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "description": description,
            "location": location,
            "date": Timestamp(date: date),
            "isOffCampus": isOffCampus,
            "rsvp": rsvp,
            "organizer": organizer
        ]
    }
}
