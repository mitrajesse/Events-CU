//
//  EventDetailView.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Firebase

// MARK: - Event Detail View
struct EventDetailView: View {
    @State var event: Event
    @EnvironmentObject var userViewModel: UserViewModel // Bindable to an @Observable object

    @State private var isRSVPed: Bool = false
    @State private var isShareSheetShowing = false
    @State private var errorMessage: String? = nil
    @State private var showErrorAlert: Bool = false // Tracks whether to show the error alert

    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)) // Hex color #fcb716
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // Hex color #003865

    var body: some View {
        NavigationView {
            ZStack {
                // Set entire background to appBackgroundColor
                appBackgroundColor.ignoresSafeArea()

                VStack {
                    // Centered Event Title, Date, Location, and Host
                    VStack(alignment: .center, spacing: 8) {
                        Text(event.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(barBackgroundColor)

                        Text("Date: \(formattedDate(event.date))")
                            .font(.title2)
                            .foregroundColor(barBackgroundColor)

                        Text("Location: \(event.location)")
                            .font(.title2)
                            .foregroundColor(barBackgroundColor)

                        Text("Hosted By: \(event.organizer)")
                            .font(.title2)
                            .foregroundColor(barBackgroundColor)
                    }
                    .frame(maxWidth: .infinity) // Center align by taking full width
                    .multilineTextAlignment(.center) // Center the text within the VStack
                    .padding(.horizontal)

                    // Event Description Box
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            Text(event.description)
                                .foregroundColor(.white)
                                .font(.body)
                                .padding()
                        )

                    Spacer()

                    // Centered HStack with icon-only buttons at the bottom of the screen
                    HStack(spacing: 40) {
                        Button(action: toggleRSVP) {
                            Image(systemName: isRSVPed ? "checkmark.circle.fill" : "checkmark.circle") // RSVP icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(barBackgroundColor)
                        }

                        Button(action: {
                            isShareSheetShowing = true // Show the share sheet
                        }) {
                            Image(systemName: "square.and.arrow.up") // Share icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(barBackgroundColor)
                        }
                        .sheet(isPresented: $isShareSheetShowing) {
                            ShareSheet(activityItems: ["Check out this event: \(event.name) on \(formattedDate(event.date)) at \(event.location)"])
                                .presentationDetents([.medium, .large]) // Present at half screen by default
                        }

                        Button(action: {
                            if let url = URL(string: "https://forms.gle/aRz3PPLG9QSFQuAM8") { // Replace with the actual URL
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "exclamationmark.triangle") // Report icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(barBackgroundColor)
                        }
                    }
                    .frame(maxWidth: .infinity) // Center the HStack
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
            }
        }
        .onAppear {
            // Check if the user is already RSVP'd
            if let userId = userViewModel.currentUser?.id {
                isRSVPed = event.rsvp.contains(userId)
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

    // MARK: - Helper Functions
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func toggleRSVP() {
        guard let userId = userViewModel.currentUser?.id else {
            errorMessage = "You must be signed in to RSVP."
            showErrorAlert = true
            return
        }

        errorMessage = nil

        // Toggle RSVP
        if isRSVPed {
            if let index = event.rsvp.firstIndex(of: userId) {
                event.rsvp.remove(at: index)
            }
        } else {
            event.rsvp.append(userId)
        }

        updateEventInFirestore()
        isRSVPed.toggle()
    }

    private func updateEventInFirestore() {
        let db = Firestore.firestore()
        db.collection("Events").document(event.id).setData(event.toDictionary(), merge: true) { error in
            if let error = error {
                errorMessage = "Failed to update RSVP: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
}
