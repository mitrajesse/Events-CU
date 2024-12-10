//
//  AboutUsView.swift
//  Events@CU
//
//  Created by Jesse Mitra on 11/12/24.
//

import SwiftUI

struct AboutUsView: View {
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // Hex color #003865
    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)) // Hex color #fcb716
    
    var body: some View {
        ZStack {
            // Set the entire background to appBackgroundColor
            appBackgroundColor.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title with matching color from EventDetailView
                Text("About Us")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(barBackgroundColor)
                
                // Developers Section
                VStack(spacing: 10) {
                    Text("Developers")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("Events@CU was created by a dedicated team of two developers with a passion for connecting students to campus events. Our mission is to simplify staying informed and engaged with the vibrant activities happening across Cedarville University.")
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(barBackgroundColor) // Matching background color
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Donations Section
                VStack(spacing: 10) {
                    Text("Support Us")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("Thank you so much for choosing to support us! This app was made possible through donations, and we are extremely grateful for the effort you're putting in to keep this project going.")
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    // Donations Button
                    Button(action: openDonationLink) {
                        Text("Donate Now")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(appBackgroundColor) // Matching app background color
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
                .background(barBackgroundColor) // Matching rounded rectangle background color
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // Function to open the donations link
    private func openDonationLink() {
        if let url = URL(string: "https://venmo.com/code?user_id=3654868279494399992&created=1733264769") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    AboutUsView()
}
