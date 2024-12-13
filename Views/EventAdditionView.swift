//
//  EventAdditionView.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI
import FirebaseFirestore

struct EventAdditionView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var date: Date = Date()
    @State private var isOffCampus: Bool = false
    @State private var errorMessage: String? = nil
    @State private var isSubmitting: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var organizer: String = ""

    @EnvironmentObject var userViewModel: UserViewModel

    let db = Firestore.firestore()

    var body: some View {
        ZStack {
            Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Add New Event")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                    .padding()

                ScrollView {
                    VStack(spacing: 15) {
                        TextField("Event Name", text: $name)
                            .autocapitalization(.words)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .accentColor(.black)
                            .colorScheme(.light)
                        
                        TextField("Organized By", text: $organizer)
                            .autocapitalization(.words)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .accentColor(.black)
                            .colorScheme(.light)

                        VStack(alignment: .leading) {
                            Text("Description")
                                .foregroundColor(.white)
                            TextEditor(text: $description)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .frame(height: 150)
                                .accentColor(.black)
                                .colorScheme(.light)
                        }

                        TextField("Event Location", text: $location)
                            .autocapitalization(.words)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .accentColor(.black)
                            .colorScheme(.light)

                        DatePicker("Event Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .accentColor(.black)
                            .colorScheme(.light)

                        Toggle("Off-Campus Event", isOn: $isOffCampus)
                            .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .accentColor(.black)
                            .colorScheme(.light)
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    addEvent()
                }) {
                    Text(isSubmitting ? "Submitting..." : "Add Event")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmitting ? Color.gray : Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .disabled(isSubmitting)
                .padding(.horizontal)

                Spacer()
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"), action: {
                    errorMessage = nil
                })
            )
        }
    }

    // MARK: - Add Event to Firestore
    private func addEvent() {
        guard !name.isEmpty, !organizer.isEmpty, !description.isEmpty, !location.isEmpty else {
            errorMessage = "Please fill in all fields."
            showErrorAlert = true
            return
        }

        isSubmitting = true

        let newEvent = Event(
            id: UUID().uuidString,
            name: name,
            description: description,
            location: location,
            date: date,
            isOffCampus: isOffCampus,
            organizer: organizer
        )

        db.collection("Events").document(newEvent.id).setData(newEvent.toDictionary()) { error in
            isSubmitting = false
            if let error = error {
                self.errorMessage = "Please sign in to add an event."
                showErrorAlert = true
            } else {
                self.errorMessage = nil
                clearFields()
            }
        }
    }

    // MARK: - Clear Input Fields
    private func clearFields() {
        name = ""
        description = ""
        location = ""
        date = Date()
        isOffCampus = false
        organizer = ""
    }
}

#Preview {
    EventAdditionView()
}
