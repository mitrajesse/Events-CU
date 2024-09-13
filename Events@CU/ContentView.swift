import SwiftUI

struct ContentView: View {
    // Constants for reused colors
    let buttonTextColor = Color(UIColor.systemGray6)
    let buttonBackgroundBlue = Color(UIColor.systemBlue)
    let buttonBackgroundGreen = Color(UIColor.systemGreen)
    let iconAndTextColor = Color(UIColor.systemGray2)
    let opaqueGray = Color(UIColor.systemGray).opacity(0.3)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea() // Full-screen black background
                
                VStack {
                    // Top Bar
                    topMenuBar()
                    
                    Spacer()
                    
                    // Main Text Bubble
                    mainTextBubble()
                    
                    Spacer()
                    
                    // Bottom Bar with Buttons
                    bottomBar()
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("") // Ensure navigation title isn't overridden
        }
    }
    
    // MARK: - Top Menu Bar
    @ViewBuilder
    private func topMenuBar() -> some View {
        ZStack {
            Rectangle()
                .fill(opaqueGray)
                .frame(height: 70)
            
            HStack {
                IconButton(imageName: "line.horizontal.3", action: {
                    // Handle hamburger menu action
                })
                
                Spacer()
                
                accountButton()
            }
            .padding(.horizontal)
        }
    }
    
    private func accountButton() -> some View {
        Button(action: {
            // Handle account button action
        }) {
            HStack {
                Text("Account")
                    .foregroundColor(iconAndTextColor)
                    .font(.system(size: 22))
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(iconAndTextColor)
            }
        }
        .padding()
    }
    
    // MARK: - Main Text Bubble
    @ViewBuilder
    private func mainTextBubble() -> some View {
        ZStack {
            BubbleShape()
                .fill(Color.yellow)
                .frame(width: 270, height: 160)  // Shrink the width and expand the height slightly
            
            Text("Hey there\nYellow Jacket!")
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .font(.system(size: 32))
                .padding()
        }
    }
    
    // MARK: - Bottom Bar with Buttons
    @ViewBuilder
    private func bottomBar() -> some View {
        ZStack {
            Rectangle()
                .fill(opaqueGray)
                .frame(height: 100) // Opaque bar behind buttons

            HStack(spacing: 40) {
                // On Campus Events Button (House Icon)
                NavigationLink(destination: EventListView()) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(buttonBackgroundBlue)
                }
                
                // Off Campus Events Button (Car Icon)
                NavigationLink(destination: OffCampusEventListView()) {
                    Image(systemName: "car.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(buttonBackgroundGreen)
                }
            }
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Event List View (On Campus Events)
struct EventListView: View {
    @State private var events: [Event] = Event.sampleData
    @State private var sortMethod: SortMethod = .date // Track sorting method
    @State private var sortAscending = true // Track sort order
    
    enum SortMethod: String, CaseIterable, Identifiable {
        case date = "Date"
        case alphabetically = "Alphabetically"
        case interested = "People Interested"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        VStack {
            // List of On Campus Events
            List(events) { event in
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.date)
                            .font(.headline)
                            .foregroundColor(.white) // White text for dark mode
                        Text(event.name)
                            .foregroundColor(.white) // White text for dark mode
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(event.interestedPeople) Interested")
                            .font(.subheadline)
                            .foregroundColor(.gray) // Adjusted color for dark mode
                        Text(event.rsvpStatus)
                            .font(.subheadline)
                            .foregroundColor(event.rsvpStatus == "RSVP'd" ? .green : .gray)
                    }
                }
                .padding()
                .listRowBackground(Color.black) // Make the background of each row dark
            }
            .listStyle(PlainListStyle()) // Customize list style if needed
        }
        .background(Color.black) // Black background behind the list
        .navigationBarTitleDisplayMode(.inline) // Set inline title
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack { // Use HStack to move text more to the left
                    Text("On Campus")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold)) // Larger text with bold weight
                    Spacer()
                }
            }
            
            // Sort button with opaque background
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    Capsule()
                        .fill(Color.gray.opacity(0.5)) // Opaque background
                        .frame(height: 40)
                    
                    Menu {
                        Button(action: { handleSort(.date) }) {
                            Label(sortMethod == .date ? (sortAscending ? "Date (Ascending)" : "Date (Descending)") : "Date", systemImage: "calendar")
                        }
                        Button(action: { handleSort(.alphabetically) }) {
                            Label(sortMethod == .alphabetically ? (sortAscending ? "Alphabetically (Ascending)" : "Alphabetically (Descending)") : "Alphabetically", systemImage: "textformat")
                        }
                        Button(action: { handleSort(.interested) }) {
                            Label(sortMethod == .interested ? (sortAscending ? "People Interested (Ascending)" : "People Interested (Descending)") : "People Interested", systemImage: "person.3")
                        }
                    } label: {
                        HStack {
                            Text("Sort")
                                .foregroundColor(.white)
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .frame(height: 40)
                    }
                }
            }
        }
    }
    
    private func handleSort(_ method: SortMethod) {
        if sortMethod == method {
            sortAscending.toggle()
        } else {
            sortMethod = method
            sortAscending = true
        }
        sortEvents()
    }
    
    private func sortEvents() {
        switch sortMethod {
        case .date:
            events.sort { sortAscending ? $0.date < $1.date : $0.date > $1.date }
        case .alphabetically:
            events.sort { sortAscending ? $0.name < $1.name : $0.name > $1.name }
        case .interested:
            events.sort { sortAscending ? $0.interestedPeople < $1.interestedPeople : $1.interestedPeople < $0.interestedPeople }
        }
    }
}

// MARK: - Off Campus Events List View
struct OffCampusEventListView: View {
    @State private var events: [Event] = Event.offCampusSampleData
    @State private var sortMethod: SortMethod = .date // Track sorting method
    @State private var sortAscending = true // Track sort order
    
    enum SortMethod: String, CaseIterable, Identifiable {
        case date = "Date"
        case alphabetically = "Alphabetically"
        case interested = "People Interested"
        case location = "Location" // Added new sort method for location
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        VStack {
            // List of Off Campus Events
            List(events) { event in
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.date)
                            .font(.headline)
                            .foregroundColor(.white) // White text for dark mode
                        Text(event.name)
                            .foregroundColor(.white) // White text for dark mode
                        Text(event.location) // Displaying location
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(event.interestedPeople) Interested")
                            .font(.subheadline)
                            .foregroundColor(.gray) // Adjusted color for dark mode
                        Text(event.rsvpStatus)
                            .font(.subheadline)
                            .foregroundColor(event.rsvpStatus == "RSVP'd" ? .green : .gray)
                    }
                }
                .padding()
                .listRowBackground(Color.black) // Make the background of each row dark
            }
            .listStyle(PlainListStyle()) // Customize list style if needed
        }
        .background(Color.black) // Black background behind the list
        .navigationBarTitleDisplayMode(.inline) // Set inline title
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack { // Use HStack to move text more to the left
                    Text("Off Campus")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold)) // Larger text with bold weight
                    Spacer()
                }
            }
            
            // Sort button with opaque background
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    Capsule()
                        .fill(Color.gray.opacity(0.5)) // Opaque background
                        .frame(height: 40)
                    
                    Menu {
                        Button(action: { handleSort(.date) }) {
                            Label(sortMethod == .date ? (sortAscending ? "Date (Ascending)" : "Date (Descending)") : "Date", systemImage: "calendar")
                        }
                        Button(action: { handleSort(.alphabetically) }) {
                            Label(sortMethod == .alphabetically ? (sortAscending ? "Alphabetically (Ascending)" : "Alphabetically (Descending)") : "Alphabetically", systemImage: "textformat")
                        }
                        Button(action: { handleSort(.interested) }) {
                            Label(sortMethod == .interested ? (sortAscending ? "People Interested (Ascending)" : "People Interested (Descending)") : "People Interested", systemImage: "person.3")
                        }
                        Button(action: { handleSort(.location) }) { // Added location sorting option
                            Label(sortMethod == .location ? (sortAscending ? "Location (Ascending)" : "Location (Descending)") : "Location", systemImage: "mappin.and.ellipse")
                        }
                    } label: {
                        HStack {
                            Text("Sort")
                                .foregroundColor(.white)
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .frame(height: 40)
                    }
                }
            }
        }
    }
    
    private func handleSort(_ method: SortMethod) {
        if sortMethod == method {
            sortAscending.toggle()
        } else {
            sortMethod = method
            sortAscending = true
        }
        sortEvents()
    }
    
    private func sortEvents() {
        switch sortMethod {
        case .date:
            events.sort { sortAscending ? $0.date < $1.date : $0.date > $1.date }
        case .alphabetically:
            events.sort { sortAscending ? $0.name < $1.name : $0.name > $1.name }
        case .interested:
            events.sort { sortAscending ? $0.interestedPeople < $1.interestedPeople : $1.interestedPeople < $0.interestedPeople }
        case .location:
            events.sort { sortAscending ? $0.location < $1.location : $1.location < $0.location }
        }
    }
}

// MARK: - Event Model
struct Event: Identifiable {
    let id = UUID()
    let date: String
    let name: String
    let location: String // Added location field
    let interestedPeople: Int
    let rsvpStatus: String
    
    static let sampleData: [Event] = [
        Event(date: "Sept 15, 2024", name: "Music Festival", location: "Auditorium", interestedPeople: 50, rsvpStatus: "RSVP'd"),
        Event(date: "Sept 20, 2024", name: "Tech Talk", location: "Main Hall", interestedPeople: 120, rsvpStatus: "Not RSVPd"),
        Event(date: "Sept 25, 2024", name: "Career Fair", location: "Conference Center", interestedPeople: 200, rsvpStatus: "RSVP'd"),
        Event(date: "Oct 1, 2024", name: "Art Exhibition", location: "Gallery", interestedPeople: 80, rsvpStatus: "RSVP'd"),
        Event(date: "Oct 5, 2024", name: "Startup Pitch", location: "Startup Hub", interestedPeople: 150, rsvpStatus: "Not RSVPd"),
        Event(date: "Oct 10, 2024", name: "Networking Event", location: "Banquet Hall", interestedPeople: 90, rsvpStatus: "RSVP'd"),
        Event(date: "Oct 15, 2024", name: "Hackathon", location: "Tech Lab", interestedPeople: 180, rsvpStatus: "Not RSVPd"),
        Event(date: "Oct 20, 2024", name: "Cooking Class", location: "Kitchen Studio", interestedPeople: 60, rsvpStatus: "RSVP'd")
    ]
    
    static let offCampusSampleData: [Event] = [
        Event(date: "Sept 10, 2024", name: "Mountain Hike", location: "Mountain Base", interestedPeople: 40, rsvpStatus: "RSVP'd"),
        Event(date: "Sept 17, 2024", name: "Beach Cleanup", location: "Sandy Beach", interestedPeople: 75, rsvpStatus: "RSVP'd"),
        Event(date: "Sept 30, 2024", name: "City Concert", location: "Downtown Plaza", interestedPeople: 180, rsvpStatus: "RSVP'd"),
        Event(date: "Oct 5, 2024", name: "Local Art Show", location: "City Gallery", interestedPeople: 100, rsvpStatus: "Not RSVPd"),
        Event(date: "Oct 12, 2024", name: "Food Truck Festival", location: "Town Square", interestedPeople: 220, rsvpStatus: "RSVP'd"),
        Event(date: "Oct 20, 2024", name: "Rock Climbing Trip", location: "Cliffside Park", interestedPeople: 50, rsvpStatus: "Not RSVPd"),
        Event(date: "Oct 27, 2024", name: "Camping Retreat", location: "Forest Reserve", interestedPeople: 80, rsvpStatus: "RSVP'd"),
        Event(date: "Nov 5, 2024", name: "Local Brewery Tour", location: "City Brewery", interestedPeople: 150, rsvpStatus: "RSVP'd")
    ]
}

// Reusable icon button
struct IconButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(UIColor.systemGray2))
                .padding()
        }
    }
}

// Custom speech bubble shape
struct BubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let bubbleCornerRadius: CGFloat = 20 // Reduced corner radius for a more square look
        let bubbleTailSize: CGFloat = 20
        
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height - bubbleTailSize),
                            cornerSize: CGSize(width: bubbleCornerRadius, height: bubbleCornerRadius))
        
        path.move(to: CGPoint(x: bubbleTailSize, y: rect.height - bubbleTailSize))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: bubbleTailSize * 2, y: rect.height - bubbleTailSize))
        
        return path
    }
}

#Preview {
    ContentView()
}
