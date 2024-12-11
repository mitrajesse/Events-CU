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
    @State private var showErrorAlert: Bool = false // Tracks whether to show the error alert
    @State private var organizer: String = ""

    @EnvironmentObject var userViewModel: UserViewModel // Assuming the organizer is the logged-in user

    let db = Firestore.firestore()

    var body: some View {
        ZStack {
            Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // Hex #003865
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Add New Event")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))) // Hex #fcb716
                    .padding()

                VStack(spacing: 15) {
                    TextField("Event Name", text: $name)
                        .autocapitalization(.words)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    TextField("Organized By", text: $organizer)
                        .autocapitalization(.words)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text("Description")
                            .foregroundColor(.white)
                        TextEditor(text: $description)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .frame(height: 150)
                    }

                    TextField("Event Location", text: $location)
                        .autocapitalization(.words)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                    DatePicker("Event Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                    Toggle("Off-Campus Event", isOn: $isOffCampus)
                        .toggleStyle(SwitchToggleStyle(tint: Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
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

                Spacer()
            }
            .padding()
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
        guard !name.isEmpty, !description.isEmpty, !location.isEmpty else {
            errorMessage = "Please fill in all fields."
            showErrorAlert = true
            return
        }

        isSubmitting = true

        let organizerName = userViewModel.currentUser?.name ?? "Unknown Organizer"

        // Create a new Event object
        let newEvent = Event(
            id: UUID().uuidString,
            name: name,
            description: description,
            location: location,
            date: date,
            isOffCampus: isOffCampus,
            rsvp: [],
            organizer: organizer

        )

        // Save to Firestore
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
