//
//  ContactUsView.swift
//  Events@CU
//
//  Created by Jesse Mitra on 11/12/24.
//

import SwiftUI

struct ContactUsView: View {
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // Hex color #003865
    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)) // Hex color #fcb716
    
    var body: some View {
        ZStack {
            // Set the background to appBackgroundColor
            appBackgroundColor.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 20) {
                
                // Centered Contact Us Title
                Text("Contact Us")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(barBackgroundColor)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Contact Campus Security Button - Phone Call
                Button(action: {
                    let phoneNumber = "tel://1234567890" // Phone number format for phone link
                    if let url = URL(string: phoneNumber), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Contact Campus Security")
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(barBackgroundColor)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                
                // Contact Developers Button - Email
                Button(action: {
                    let emailAddress = "mailto:jessemitra@cedarville.edu" // Email link format
                    if let url = URL(string: emailAddress), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Contact Developers")
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(barBackgroundColor)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                
                // Feedback Form Button - Opens Google Form in Browser
                Button(action: {
                    if let url = URL(string: "https://forms.gle/ox9AxSgLzCs6XiQ69"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Feedback Form")
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(barBackgroundColor)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContactUsView()
}
