import SwiftUI

struct OnCampusView: View {
    @EnvironmentObject var eventsViewModel: EventsViewModel // Access global instance

    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))

    var body: some View {
        VStack {
            List(eventsViewModel.onCampusEvents) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                        Text(event.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                        Text(event.location)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(barBackgroundColor)
                    }
                    .padding()
                }
                .listRowBackground(appBackgroundColor)
            }
            .listStyle(PlainListStyle())
        }
        .background(appBackgroundColor.ignoresSafeArea())
        .navigationBarTitle("On Campus", displayMode: .inline)
        .onAppear {
            configureNavigationBarAppearance()
            eventsViewModel.fetchEvents(isOffCampus: false) { _ in
                // No need to manually update, view updates automatically
            }
        }
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(appBackgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
