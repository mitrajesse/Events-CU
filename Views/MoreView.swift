import SwiftUI

struct MoreView: View {
    let backgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1)) // View background color
    let buttonColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)) // Button background color
    
    var body: some View {
        ZStack {
            // Background Color
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) { // Increased spacing between text and buttons
                Text("More")
                    .font(.system(size: 48, weight: .bold)) // Larger, bold text
                    .foregroundColor(buttonColor) // Changed text color to match button color
                    .padding(.bottom, 60)
                
                // Buttons
                Group {
                    NavigationLink(destination: EventAdditionView()) {
                        createButton(title: "Add an Event")
                    }
                    NavigationLink(destination: EditEventsView()) {
                        createButton(title: "Edit or Remove Events")
                    }
                    NavigationLink(destination: RSVPEventsView()) {
                        createButton(title: "RSVP'd Events")
                    }
                    NavigationLink(destination: ContactUsView()) {
                        createButton(title: "Contact Us")
                    }
                    NavigationLink(destination: AboutUsView()) {
                        createButton(title: "About")
                    }
                }
            }
            .padding()
        }
    }
    
    // Helper method to create a button
    private func createButton(title: String) -> some View {
        Text(title)
            .font(.headline)
            .bold()
            .frame(maxWidth: .infinity, minHeight: 50) // Full-width button
            .background(buttonColor)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationStack {
        MoreView()
    }
}
