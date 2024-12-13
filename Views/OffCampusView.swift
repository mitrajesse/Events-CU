//
//  OffCampusView.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI

struct OffCampusView: View {
    @EnvironmentObject var eventsViewModel: EventsViewModel

    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))

    var body: some View {
        VStack {
            List {
                ForEach(eventsViewModel.sortedOffCampusEvents) { event in
                    VStack(alignment: .leading, spacing: 4) {
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
                        }
                        Divider()
                            .background(Color.white.opacity(0.5)) // Customize divider appearance
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(appBackgroundColor)
            }
            .listStyle(PlainListStyle())
        }
        .background(appBackgroundColor.ignoresSafeArea())
        .navigationBarTitle("Off Campus", displayMode: .inline)
        .navigationBarItems(trailing: SortMenuButton(sortOrder: $eventsViewModel.sortOrder, barBackgroundColor: barBackgroundColor)) // Add sort button
        .onAppear {
            eventsViewModel.fetchEvents(isOffCampus: true) { _ in
                // Events fetched automatically update the list
            }
        }
    }
}
