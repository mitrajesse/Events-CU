//
//  MyEventsView.swift
//  Events@CU
//
//  Created by Jesse Mitra on 11/12/24.
//

import SwiftUI

struct EditEventsView: View {
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // Hex color #003865
    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)) // Hex color #fcb716
    
    var body: some View {
        ZStack {
            // Set the background color to match the other views
            appBackgroundColor.ignoresSafeArea()
            
            VStack {
                // Title text styled similarly to other views
                Text("My Events")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(barBackgroundColor)
                    .padding(.bottom, 20)
                
                // Additional content can be added here
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    EditEventsView()
}
